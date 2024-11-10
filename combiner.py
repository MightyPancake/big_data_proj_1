#!/usr/bin/env python3
import sys

current_key = None
sums = {
    "pieszy": {"ranny": 0, "zabity": 0},
    "rowerzysta": {"ranny": 0, "zabity": 0},
    "kierowca": {"ranny": 0, "zabity": 0}
}

for line in sys.stdin:
    parts = line.strip().split("\t")
    if len(parts) != 4:
        continue

    key, victim_type, injury_type, count = parts
    count = int(count)

    if current_key == key:
        sums[victim_type][injury_type] += count
    else:
        if current_key:
            for victim, injury_data in sums.items():
                for injury_type, total in injury_data.items():
                    if total > 0:
                        print(f"{current_key}\t{victim}\t{injury_type}\t{total}")

        current_key = key
        sums = {
            "pieszy": {"ranny": 0, "zabity": 0},
            "rowerzysta": {"ranny": 0, "zabity": 0},
            "kierowca": {"ranny": 0, "zabity": 0}
        }
        
  
