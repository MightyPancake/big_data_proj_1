#!/usr/bin/env python3
import sys

for line in sys.stdin:
    parts = line.strip().split("\t")
    if len(parts) != 4:
        continue
    full_key, victim_type, injury_type, count = parts
    street, zip_code = full_key.split("^")
    print(f"{street}\t{zip_code}\t{victim_type}\t{injury_type}\t{count}")
