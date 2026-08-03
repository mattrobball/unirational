#!/usr/bin/env python3
"""Extract a ChatGPT share-link conversation to markdown.

Usage:
  python3 extract_chatgpt_share.py <share-url-or-html-file> [-o out.md]

Share pages embed the conversation as a React Router turbo-stream payload
inside streamController.enqueue("...") script chunks; WebFetch/markdown
converters drop it. We decode the reference-graph format directly.
"""
import json
import re
import subprocess
import sys

UA = ("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 "
      "(KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36")


def fetch(source):
    if re.match(r"https?://", source):
        return subprocess.run(
            ["curl", "-sL", "-A", UA, source],
            capture_output=True, text=True, check=True,
        ).stdout
    with open(source) as f:
        return f.read()


def payload_lines(html):
    chunks = re.findall(r'streamController\.enqueue\(("(?:[^"\\]|\\.)*")\);', html)
    text = "".join(json.loads(c) for c in chunks)
    return [ln for ln in text.split("\n") if ln.strip()]


class Decoder:
    """Turbo-stream flat-array reference graph -> python objects."""

    def __init__(self, arr):
        self.arr = arr
        self.memo = {}

    def get(self, i):
        if not isinstance(i, int) or i < 0:
            return None  # negative codes: undefined/NaN/Infinity/etc.
        if i in self.memo:
            return self.memo[i]
        v = self.arr[i]
        if isinstance(v, dict):
            out = {}
            self.memo[i] = out
            for k, val in v.items():
                key = self.arr[int(k[1:])] if k.startswith("_") else k
                out[key] = self.get(val)
            return out
        if isinstance(v, list):
            out = []
            self.memo[i] = out
            out.extend(self.get(x) for x in v)
            return out
        return v


def find_mapping(node, seen=None):
    """Find the conversation mapping: dict of id -> {message, parent, children}."""
    if seen is None:
        seen = set()
    if id(node) in seen:
        return None
    seen.add(id(node))
    if isinstance(node, dict):
        vals = list(node.values())
        if vals and all(isinstance(v, dict) and "children" in v for v in vals):
            if any(isinstance(v.get("message"), dict) for v in vals):
                return node
        for v in vals:
            found = find_mapping(v, seen)
            if found:
                return found
    elif isinstance(node, list):
        for v in node:
            found = find_mapping(v, seen)
            if found:
                return found
    return None


def linearize(mapping):
    roots = [k for k, v in mapping.items() if not v.get("parent")]
    order, cur = [], roots[0] if roots else None
    while cur is not None:
        node = mapping[cur]
        if isinstance(node.get("message"), dict):
            order.append(node["message"])
        kids = node.get("children") or []
        cur = kids[-1] if kids else None  # last child = current branch
    return order


def render_message(msg):
    role = (msg.get("author") or {}).get("role", "?")
    content = msg.get("content") or {}
    ctype = content.get("content_type")
    pieces = []
    if ctype == "text":
        pieces = [p for p in (content.get("parts") or []) if isinstance(p, str)]
    elif ctype == "code":
        t = content.get("text")
        if t:
            pieces = ["```\n%s\n```" % t]
    elif ctype == "thoughts":
        for th in content.get("thoughts") or []:
            if isinstance(th, dict) and th.get("content"):
                pieces.append("> [thought] " + th["content"].replace("\n", "\n> "))
    elif ctype == "multimodal_text":
        for p in content.get("parts") or []:
            if isinstance(p, str):
                pieces.append(p)
    text = "\n\n".join(p for p in pieces if p and p.strip())
    if not text:
        return None
    return role, text


def main():
    argv = sys.argv[1:]
    out = None
    if "-o" in argv:
        i = argv.index("-o")
        out = argv[i + 1]
        del argv[i:i + 2]
    if len(argv) != 1:
        sys.exit(__doc__)
    html = fetch(argv[0])
    title = None
    m = re.search(r"<title[^>]*>(.*?)</title>", html, re.S)
    if m:
        title = re.sub(r"\s*\|?\s*ChatGPT.*$", "", m.group(1).strip()) or None

    mapping = None
    for line in payload_lines(html):
        try:
            arr = json.loads(line)
        except json.JSONDecodeError:
            continue
        mapping = find_mapping(Decoder(arr).get(0))
        if mapping:
            break
    if not mapping:
        sys.exit("ERROR: no conversation mapping found in payload")

    lines = ["# %s" % (title or "ChatGPT conversation"), ""]
    n = 0
    for msg in linearize(mapping):
        rendered = render_message(msg)
        if not rendered:
            continue
        role, text = rendered
        n += 1
        lines.append("## [%d] %s" % (n, role))
        lines.append("")
        lines.append(text)
        lines.append("")
    result = "\n".join(lines)
    if out:
        with open(out, "w") as f:
            f.write(result)
        print("wrote %s (%d messages, %d chars)" % (out, n, len(result)))
    else:
        print(result)


if __name__ == "__main__":
    main()
