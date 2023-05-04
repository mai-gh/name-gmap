#!/usr/bin/env python

import os
import string
import sys

if len(sys.argv) < 3 or not os.path.isfile(sys.argv[1]):
  print("first arg must be the file to edit (gmapsupp.img)")
  print("second arg must be the name to give")
  sys.exit(1)

input_fn = sys.argv[1]
input_str = " ".join(sys.argv[2:])

if len(input_str) == 0 or len(input_str) > 20 or not input_str.isascii():
  print("invalid input")
  print("name must be greater in length than 0 and less than 21")
  print("name must be an ascii character. use any of the following:")
  print(string.printable)
  sys.exit(1)

input_str_b = input_str.ljust(20).encode('ascii')

with open(input_fn, "rb+") as f:
  f.seek(0x49, 0)
  print(f"ORIGINAL: {f.read(20)}")
  print(f"NEW:      {input_str_b}")
  f.seek(0x49, 0)
  f.write(input_str_b)
  f.seek(0x49, 0)
  print(f"WRITTEN:  {f.read(20)}")
