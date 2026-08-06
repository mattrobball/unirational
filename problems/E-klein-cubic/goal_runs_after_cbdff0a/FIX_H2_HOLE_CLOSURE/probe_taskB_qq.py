import os, h2_engines as E
E.NTH = '3'
import h2_taskB as TB
TB.run(3, 'om', tmo=1200, mode='qq', limit=2)
