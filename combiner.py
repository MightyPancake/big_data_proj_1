#!/usr/bin/env python3

import sys

current_key = None
injured_sum = 0
killed_sum = 0

def output_combiner(key, injured_sum, killed_sum):
    if injured_sum > 0:
        print(f"{key[0]}\t{key[1]}\t{key[2]}\tranny\t{injured_sum}")
    if killed_sum > 0:
        print(f"{key[0]}\t{key[1]}\t{key[2]}\tzabity\t{killed_sum}")

# Przechodzimy po liniach z wejścia
for line in sys.stdin:
    parts = line.strip().split("\t")
    
    if len(parts) != 5:
        continue  # Pomijamy niepoprawne linie

    street, zip_code, victim_type, injury_type, count = parts
    count = int(count)
    key = (street, zip_code, victim_type)

    # Gromadzimy sumy dla tego samego klucza
    if key == current_key:
        if injury_type == "ranny":
            injured_sum += count
        elif injury_type == "zabity":
            killed_sum += count
    else:
        # Wypisujemy wynik dla poprzedniego klucza
        if current_key:
            output_combiner(current_key, injured_sum, killed_sum)

        # Resetujemy zmienne dla nowego klucza
        current_key = key
        injured_sum = count if injury_type == "ranny" else 0
        killed_sum = count if injury_type == "zabity" else 0

# Wypisujemy ostatni wynik
if current_key:
    output_combiner(current_key, injured_sum, killed_sum)
