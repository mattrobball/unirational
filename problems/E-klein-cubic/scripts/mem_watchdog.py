#!/usr/bin/env python3
"""Memory watchdog: ONLY when used memory > 95%, kill heaviest safe user processes.

Usage:
  python3 mem_watchdog.py              # one-shot check
  python3 mem_watchdog.py --loop 60    # poll every 60s, print only on action/state change
  python3 mem_watchdog.py --dry-run    # report what would be killed, never kill

Threshold: system free% from memory_pressure, fallback vm_stat.
Action threshold: used > 95%  <=>  free < 5%.
"""
from __future__ import annotations

import argparse
import ctypes
import ctypes.util
import os
import re
import signal
import subprocess
import sys
import time
from typing import List, Tuple

USED_THRESHOLD_PCT = 95  # act ONLY above this
FREE_ACTION_PCT = 100 - USED_THRESHOLD_PCT  # free <= 5%
TARGET_AFTER_KILL_USED = 90  # stop killing once used drops to this
MAX_KILLS_PER_CYCLE = 3

# Never kill these (name match, case-sensitive basename-ish)
PROTECTED_EXACT = {
    "kernel_task", "launchd", "WindowServer", "loginwindow", "SystemUIServer",
    "Dock", "Finder", "cfprefsd", "distnoted", "UserEventAgent", "sshd",
    "sshd-session", "syslogd", "mds", "mds_stores", "mDNSResponder",
    "coreaudiod", "bluetoothd", "configd", "powerd", "notifyd", "securityd",
    "trustd", "tccd", "launchservicesd", "fseventsd", "logd", "airportd",
    "AppleSpell", "universalaccessd", "talagentd", "WindowManager",
}
# Never kill if name contains these (agent/self/system)
PROTECTED_SUBSTR = (
    "grok-",  # other/current grok agents — avoid suicide of sibling agents casually
    "com.apple.",
)

# Prefer killing these first when over threshold (compute hogs)
PREFER_KILL_SUBSTR = (
    "Singular", "singular", "Macaulay2", "M2", "sage", "magma",
    "python", "Python", "julia", "Julia", "R", "matlab", "octave",
    "java", "node", "chrome", "Chromium", "Code Helper", "Renderer",
)

lib = ctypes.CDLL(ctypes.util.find_library("System") or "/usr/lib/libSystem.B.dylib")
PROC_ALL_PIDS = 1
PROC_PIDTBSDINFO = 3
PROC_PIDTASKINFO = 4


class proc_bsdinfo(ctypes.Structure):
    _fields_ = [
        ("pbi_flags", ctypes.c_uint32), ("pbi_status", ctypes.c_uint32),
        ("pbi_xstatus", ctypes.c_uint32), ("pbi_pid", ctypes.c_uint32),
        ("pbi_ppid", ctypes.c_uint32), ("pbi_uid", ctypes.c_uint32),
        ("pbi_gid", ctypes.c_uint32), ("pbi_ruid", ctypes.c_uint32),
        ("pbi_rgid", ctypes.c_uint32), ("pbi_svuid", ctypes.c_uint32),
        ("pbi_svgid", ctypes.c_uint32), ("pbi_rfu", ctypes.c_uint32),
        ("pbi_comm", ctypes.c_char * 16), ("pbi_name", ctypes.c_char * 32),
        ("pbi_nfiles", ctypes.c_uint32), ("pbi_pgid", ctypes.c_uint32),
        ("pbi_pjobc", ctypes.c_uint32), ("e_tdev", ctypes.c_uint32),
        ("e_tpgid", ctypes.c_uint32), ("pbi_nice", ctypes.c_int32),
        ("pbi_start_tvsec", ctypes.c_uint64), ("pbi_start_tvusec", ctypes.c_uint64),
    ]


class proc_taskinfo(ctypes.Structure):
    _fields_ = [
        ("pti_virtual_size", ctypes.c_uint64),
        ("pti_resident_size", ctypes.c_uint64),
        ("_pad", ctypes.c_byte * 80),
    ]


lib.proc_listpids.argtypes = [ctypes.c_uint32, ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
lib.proc_listpids.restype = ctypes.c_int
lib.proc_pidinfo.argtypes = [ctypes.c_int, ctypes.c_int, ctypes.c_uint64, ctypes.c_void_p, ctypes.c_int]
lib.proc_pidinfo.restype = ctypes.c_int
lib.proc_name.argtypes = [ctypes.c_int, ctypes.c_void_p, ctypes.c_uint32]
lib.proc_name.restype = ctypes.c_int
lib.proc_pidpath.argtypes = [ctypes.c_int, ctypes.c_void_p, ctypes.c_uint32]
lib.proc_pidpath.restype = ctypes.c_int


def total_ram() -> int:
    return int(subprocess.check_output(["sysctl", "-n", "hw.memsize"]).decode().strip())


def free_percent() -> float:
    """Return free percentage (0-100). Prefer memory_pressure."""
    try:
        out = subprocess.check_output(["memory_pressure"], text=True, stderr=subprocess.DEVNULL)
        m = re.search(r"System-wide memory free percentage:\s*(\d+)%", out)
        if m:
            return float(m.group(1))
    except Exception:
        pass
    # fallback: free+purgeable / total
    page = os.sysconf("SC_PAGE_SIZE") if hasattr(os, "sysconf") else 16384
    try:
        page = int(subprocess.check_output(["pagesize"]).decode().strip())
    except Exception:
        pass
    free = purg = 0
    try:
        for line in subprocess.check_output(["vm_stat"], text=True).splitlines():
            if "Pages free" in line:
                free = int(line.split(":")[1].strip().rstrip(".")) * page
            elif "Pages purgeable" in line:
                purg = int(line.split(":")[1].strip().rstrip(".")) * page
    except Exception:
        return 100.0
    tot = total_ram()
    return 100.0 * (free + purg) / tot if tot else 100.0


def used_percent() -> float:
    return 100.0 - free_percent()


def list_user_procs(uid: int) -> List[Tuple[int, int, str, str]]:
    """Return list of (rss, pid, name, path) for processes owned by uid."""
    bufsize = lib.proc_listpids(PROC_ALL_PIDS, 0, None, 0)
    if bufsize <= 0:
        return []
    buf = (ctypes.c_int * (bufsize // 4))()
    lib.proc_listpids(PROC_ALL_PIDS, 0, buf, bufsize)
    namebuf = ctypes.create_string_buffer(256)
    pathbuf = ctypes.create_string_buffer(1024)
    rows = []
    me = os.getpid()
    for p in buf:
        if not p or p == me:
            continue
        bsd = proc_bsdinfo()
        if lib.proc_pidinfo(p, PROC_PIDTBSDINFO, 0, ctypes.byref(bsd), ctypes.sizeof(bsd)) <= 0:
            continue
        if bsd.pbi_uid != uid:
            continue
        ti = proc_taskinfo()
        if lib.proc_pidinfo(p, PROC_PIDTASKINFO, 0, ctypes.byref(ti), ctypes.sizeof(ti)) <= 0:
            continue
        namebuf.value = b""
        lib.proc_name(p, namebuf, 256)
        name = namebuf.value.decode(errors="replace") or bsd.pbi_comm.decode(errors="replace")
        pathbuf.value = b""
        lib.proc_pidpath(p, pathbuf, 1024)
        path = pathbuf.value.decode(errors="replace")
        rows.append((int(ti.pti_resident_size), int(p), name, path))
    rows.sort(reverse=True)
    return rows


def is_protected(name: str, path: str, pid: int) -> bool:
    if pid in (0, 1) or pid == os.getpid():
        return True
    # protect our ancestors
    try:
        pp = os.getppid()
        chain = set()
        # walk a few levels via bsdinfo
        cur = os.getpid()
        for _ in range(12):
            bsd = proc_bsdinfo()
            if lib.proc_pidinfo(cur, PROC_PIDTBSDINFO, 0, ctypes.byref(bsd), ctypes.sizeof(bsd)) <= 0:
                break
            chain.add(cur)
            chain.add(int(bsd.pbi_ppid))
            cur = int(bsd.pbi_ppid)
            if cur <= 1:
                break
        if pid in chain:
            return True
    except Exception:
        pass
    base = name.split()[0] if name else ""
    if base in PROTECTED_EXACT or name in PROTECTED_EXACT:
        return True
    for s in PROTECTED_SUBSTR:
        if s in name or s in path:
            # allow killing Singular even if path weird
            if "Singular" in name:
                return False
            # protect grok agent binaries
            if "grok-" in name or "grok-" in path:
                return True
            if s.startswith("com.apple") and ("/System/" in path or path.startswith("/usr/")):
                return True
    if path.startswith("/System/") or path.startswith("/usr/libexec/") or path.startswith("/usr/sbin/"):
        # system daemons — don't kill
        return True
    return False


def kill_score(name: str, rss: int) -> Tuple[int, int]:
    """Higher = kill sooner. Prefer known compute hogs, then by rss."""
    prefer = 0
    for i, s in enumerate(PREFER_KILL_SUBSTR):
        if s in name:
            prefer = 1000 - i
            break
    return (prefer, rss)


def try_kill(pid: int, name: str, dry_run: bool) -> str:
    if dry_run:
        return "dry-run"
    # SIGTERM then brief wait then SIGKILL
    try:
        os.kill(pid, signal.SIGTERM)
    except PermissionError:
        # try subprocess kill / killall style
        r = subprocess.run(["/bin/kill", "-TERM", str(pid)], capture_output=True, text=True)
        if r.returncode != 0:
            return f"blocked:{r.stderr.strip() or 'Operation not permitted'}"
    except ProcessLookupError:
        return "gone"
    except Exception as e:
        return f"err:{e}"
    time.sleep(0.8)
    try:
        os.kill(pid, 0)
    except ProcessLookupError:
        return "terminated"
    except PermissionError:
        return "signal-sent-unverified"
    try:
        os.kill(pid, signal.SIGKILL)
        time.sleep(0.2)
        try:
            os.kill(pid, 0)
            return "still-alive"
        except ProcessLookupError:
            return "killed"
        except PermissionError:
            return "sigkill-sent-unverified"
    except PermissionError:
        return "blocked:SIGKILL Operation not permitted"
    except ProcessLookupError:
        return "killed"
    except Exception as e:
        return f"err:{e}"


def act(dry_run: bool = False) -> str:
    used = used_percent()
    free = 100.0 - used
    tot = total_ram()
    tot_gb = tot / (1024**3)
    ts = time.strftime("%H:%M:%S")

    if used <= USED_THRESHOLD_PCT:
        return f"OK used={used:.0f}% free={free:.0f}% total={tot_gb:.0f}G @ {ts} (no action; need >{USED_THRESHOLD_PCT}%)"

    uid = os.getuid()
    procs = list_user_procs(uid)
    candidates = []
    for rss, pid, name, path in procs:
        if is_protected(name, path, pid):
            continue
        # skip tiny
        if rss < 50 * 1024 * 1024:
            continue
        candidates.append((kill_score(name, rss), rss, pid, name, path))
    candidates.sort(reverse=True)

    if not candidates:
        top = ", ".join(f"{n}:{rss/1024/1024:.0f}MB(pid{pid})" for rss, pid, n, _ in procs[:5])
        return (
            f"CRIT used={used:.0f}% free={free:.0f}% @ {ts} but no killable candidates "
            f"(sandbox or all protected). top={top}"
        )

    killed = []
    blocked = []
    for _, rss, pid, name, path in candidates[:MAX_KILLS_PER_CYCLE]:
        status = try_kill(pid, name, dry_run=dry_run)
        entry = f"{name}(pid={pid},{rss/1024/1024:.0f}MB):{status}"
        if status in ("terminated", "killed", "dry-run", "signal-sent-unverified", "sigkill-sent-unverified"):
            killed.append(entry)
        else:
            blocked.append(entry)
        # re-check memory; stop if recovered
        used_now = used_percent()
        if used_now <= TARGET_AFTER_KILL_USED:
            break

    used_after = used_percent()
    parts = [
        f"ACTION used_was={used:.0f}% used_now={used_after:.0f}% @ {ts}",
        f"killed=[{'; '.join(killed) or 'none'}]",
        f"blocked=[{'; '.join(blocked) or 'none'}]",
    ]
    return " ".join(parts)


def main() -> int:
    global USED_THRESHOLD_PCT, FREE_ACTION_PCT
    ap = argparse.ArgumentParser()
    ap.add_argument("--loop", type=int, default=0, help="Poll interval seconds (0=once)")
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--threshold", type=int, default=95,
                    help="Only act when used%% > this (default 95)")
    args = ap.parse_args()
    USED_THRESHOLD_PCT = args.threshold
    FREE_ACTION_PCT = 100 - USED_THRESHOLD_PCT

    last_msg_kind = None
    while True:
        msg = act(dry_run=args.dry_run)
        kind = "ACTION" if msg.startswith("ACTION") or msg.startswith("CRIT") else "OK"
        # In loop mode: print on state change, always print ACTIONs
        if args.loop <= 0:
            # monitor protocol: DONE for ok, FAILED for action/crit
            if kind == "OK":
                print(f"DONE {msg}", flush=True)
            else:
                print(f"FAILED {msg}", flush=True)
            return 0
        if kind != last_msg_kind or kind != "OK":
            if kind == "OK":
                print(f"DONE {msg}", flush=True)
            else:
                print(f"FAILED {msg}", flush=True)
            last_msg_kind = kind
        time.sleep(args.loop)


if __name__ == "__main__":
    sys.exit(main())
