#!/usr/bin/python3

import sys

# Inicjalizujemy zmienne do przechowywania aktualnego klucza oraz sum rannych i zabitych
current_key = None
injured_sum = 0
killed_sum = 0

# Przechodzimy po liniach z wejścia
for line in sys.stdin:
    parts = line.strip().split("\t")
    
    if len(parts) != 5:
        continue  # Pomijamy niepoprawne linie (np. te, które nie mają 5 elementów)

    # Rozpakowujemy dane
    street, zip_code, victim_type, injury_type, count = parts
    count = int(count)

    # Tworzymy klucz z ulicy, kodu pocztowego i typu poszkodowanego
    key = (street, zip_code, victim_type)

    # Sprawdzamy, czy aktualny klucz jest taki sam jak poprzedni
    if current_key == key:
        # Dodajemy liczbę rannych/zabitych do odpowiedniej sumy
        if injury_type == "ranny":
            injured_sum += count
        elif injury_type == "zabity":
            killed_sum += count
    else:
        # Jeśli aktualny klucz różni się od poprzedniego
        # Wypisujemy wynik dla poprzedniego klucza, jeśli suma rannych lub zabitych jest większa niż zero
        if current_key:
            if injured_sum > 0: 
                print(f"{current_key[0]}\t{current_key[1]}\t{current_key[2]}\tranny\t{injured_sum}")
            if killed_sum > 0:
                print(f"{current_key[0]}\t{current_key[1]}\t{current_key[2]}\tzabity\t{killed_sum}")

        # Ustawiamy nowy klucz i resetujemy sumy
        current_key = key
        injured_sum = count if injury_type == "ranny" else 0
        killed_sum = count if injury_type == "zabity" else 0

# Na końcu wypisujemy wynik dla ostatniego klucza, jeśli suma rannych lub zabitych jest większa niż zero
if current_key:
    if injured_sum > 0:
        print(f"{current_key[0]}\t{current_key[1]}\t{current_key[2]}\tranny\t{injured_sum}")
    if killed_sum > 0:
        print(f"{current_key[0]}\t{current_key[1]}\t{current_key[2]}\tzabity\t{killed_sum}")
