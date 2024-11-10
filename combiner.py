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

    # Jeśli zmienia się klucz, wypisujemy zgromadzone sumy dla aktualnego `current_key`
    if current_key is not None and current_key != key:
        for victim, injury_data in sums.items():
            for injury_type, total in injury_data.items():
                if total > 0:
                    print(f"{current_key}\t{victim}\t{injury_type}\t{total}")

        # Resetujemy `sums` dla nowego klucza
        sums = {
            "pieszy": {"ranny": 0, "zabity": 0},
            "rowerzysta": {"ranny": 0, "zabity": 0},
            "kierowca": {"ranny": 0, "zabity": 0}
        }

    # Ustawiamy `current_key` na nowy klucz
    current_key = key
    # Dodajemy liczność do odpowiedniego typu poszkodowanego i rodzaju obrażeń
    sums[victim_type][injury_type] += count

# Wypisujemy dane dla ostatniego klucza
if current_key is not None:
    for victim, injury_data in sums.items():
        for injury_type, total in injury_data.items():
            if total > 0:
                print(f"{current_key}\t{victim}\t{injury_type}\t{total}")
