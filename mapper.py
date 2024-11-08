#!/usr/bin/env python3

import sys

# Funkcja do konwersji liczbowej z obsługą pustych wartości
def to_int(value):
    try:
        return int(value) if value else 0
    except ValueError:
        return None  # Jeśli nie uda się przekonwertować, zwracamy None

# Mapper dla danych o wypadkach drogowych
for line in sys.stdin:
    fields = line.strip().split(",")
    
    # Zakładam, że kolumny mają określoną strukturę
    try:
        crash_date = fields[0]  # data wypadku
        zip_code = fields[2]  # kod pocztowy
        on_street_name = fields[6].upper() if fields[6] else ""  # główna ulica (zmieniamy na małe litery)
        cross_street_name = fields[7].upper() if fields[7] else ""  # ulica krzyżująca się (zmieniamy na małe litery)
        off_street_name = fields[8].upper() if fields[8] else ""  # boczna ulica (zmieniamy na małe litery)
        
        # Konwertujemy liczby rannych i zabitych z obsługą pustych wartości
        number_of_persons_injured = to_int(fields[9])
        number_of_persons_killed = to_int(fields[10])
        number_of_pedestrians_injured = to_int(fields[11])
        number_of_pedestrians_killed = to_int(fields[12])
        number_of_cyclists_injured = to_int(fields[13])
        number_of_cyclists_killed = to_int(fields[14])
        number_of_motorists_injured = to_int(fields[15])
        number_of_motorists_killed = to_int(fields[16])
    except IndexError:
        continue  # Jeśli jest problem z indeksem (brak kolumn), pomijamy tę linię

    # Sprawdzamy, czy którakolwiek z wartości liczbowych nie jest None (czyli jest błędna)
    if None in [number_of_persons_injured, number_of_persons_killed, 
                number_of_pedestrians_injured, number_of_pedestrians_killed,
                number_of_cyclists_injured, number_of_cyclists_killed,
                number_of_motorists_injured, number_of_motorists_killed]:
        continue  # Pomijamy linię, jeśli któraś liczba nie jest prawidłowa

    # Filtrujemy wypadki po 2012 roku
    if int(crash_date.split("/")[2]) <= 2012:
        continue  # Pomijamy wypadki przed rokiem 2013

    # Ustalamy, którzy poszkodowani byli w danym wypadku
    victims = [
        ("pieszy", "ranny", number_of_pedestrians_injured),
        ("pieszy", "zabity", number_of_pedestrians_killed),
        ("rowerzysta", "ranny", number_of_cyclists_injured),
        ("rowerzysta", "zabity", number_of_cyclists_killed),
        ("kierowca", "ranny", number_of_motorists_injured),
        ("kierowca", "zabity", number_of_motorists_killed),
    ]

    # Trzy ulice związane z wypadkiem
    streets = [on_street_name, cross_street_name, off_street_name]
    
    for street in streets:
        if not street:  # Pomijamy puste wartości ulic
            continue
        for victim_type, injury_type, count in victims:
            if count > 0:
                # Generujemy klucz w postaci (ulica, kod_pocztowy, typ_poszkodowanego, charakter_obrażeń)
                print(f"{street}\t{zip_code}\t{victim_type}\t{injury_type}\t{count}")
