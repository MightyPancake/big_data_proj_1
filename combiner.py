#!/usr/bin/env python3

import sys

# Inicjalizacja zmiennych do przechowywania bieżącego klucza i sum
current_key = None
injured_sum = 0
killed_sum = 0

# Przetwarzanie wejścia linia po linii
for line in sys.stdin:
    # Odczytaj i rozdziel wartości
    parts = line.strip().split("\t")
    if len(parts) != 5:
        continue  # Ignoruj linie niepasujące do oczekiwanego formatu

    # Pobierz wartości z każdej linii
    street, zip_code, victim_type, injury_type, count = parts
    count = int(count)
    
    # Zdefiniuj klucz jako (ulica, kod pocztowy, typ poszkodowanego)
    key = (street, zip_code, victim_type)

    # Sprawdź, czy klucz jest taki sam jak poprzedni
    if current_key == key:
        if injury_type == "ranny":
            injured_sum += count
        elif injury_type == "zabity":
            killed_sum += count
    else:
        # Wypisz poprzedni klucz, jeśli jest różny od bieżącego i ma wartości
        if current_key:
            if injured_sum > 0:
                print(f"{current_key[0]}\t{current_key[1]}\t{current_key[2]}\tranny\t{injured_sum}")
            if killed_sum > 0:
                print(f"{current_key[0]}\t{current_key[1]}\t{current_key[2]}\tzabity\t{killed_sum}")

        # Zresetuj zmienne dla nowego klucza
        current_key = key
        injured_sum = count if injury_type == "ranny" else 0
        killed_sum = count if injury_type == "zabity" else 0

# Wypisz ostatni klucz na koniec
if current_key:
    if injured_sum > 0:
        print(f"{current_key[0]}\t{current_key[1]}\t{current_key[2]}\tranny\t{injured_sum}")
    if killed_sum > 0:
        print(f"{current_key[0]}\t{current_key[1]}\t{current_key[2]}\tzabity\t{killed_sum}")
