#!/usr/bin/env python3
import sys

def to_int(value):
    try:
        return int(value) if value else 0
    except ValueError:
        return None

for line in sys.stdin:
    fields = line.strip().split(",")
    try:
        crash_date = fields[0]
        zip_code = fields[2]
        on_street_name = fields[6].upper() if fields[6] else ""
        cross_street_name = fields[7].upper() if fields[7] else ""
        off_street_name = fields[8].upper() if fields[8] else ""
        
        number_of_persons_injured = to_int(fields[9])
        number_of_persons_killed = to_int(fields[10])
        number_of_pedestrians_injured = to_int(fields[11])
        number_of_pedestrians_killed = to_int(fields[12])
        number_of_cyclists_injured = to_int(fields[13])
        number_of_cyclists_killed = to_int(fields[14])
        number_of_motorists_injured = to_int(fields[15])
        number_of_motorists_killed = to_int(fields[16])
    except IndexError:
        continue

    if None in [number_of_persons_injured, number_of_persons_killed, 
                number_of_pedestrians_injured, number_of_pedestrians_killed,
                number_of_cyclists_injured, number_of_cyclists_killed,
                number_of_motorists_injured, number_of_motorists_killed]:
        continue
    
    # Filter after year 2012
    if int(crash_date.split("/")[2]) <= 2012:
        continue

    victims = [
        ("pieszy", "ranny", number_of_pedestrians_injured),
        ("pieszy", "zabity", number_of_pedestrians_killed),
        ("rowerzysta", "ranny", number_of_cyclists_injured),
        ("rowerzysta", "zabity", number_of_cyclists_killed),
        ("kierowca", "ranny", number_of_motorists_injured),
        ("kierowca", "zabity", number_of_motorists_killed),
    ]
    streets = [on_street_name, cross_street_name, off_street_name]
    
    for street in streets:
        if not street:  # Pomijamy puste wartości ulic
            continue
        for victim_type, injury_type, count in victims:
            if count > 0:
                print(f"{street}^{zip_code}\t{victim_type}\t{injury_type}\t{count}")
