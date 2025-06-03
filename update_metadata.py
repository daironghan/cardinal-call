import os
import json
import re

AUDIO_DIR = "BirdCalls"
OUTPUT_FILE = "metadata.json"

# Matches: XC941857_White-crownedSparrow_ZonotrichiaLeucophrys_song.wav
FILENAME_REGEX = re.compile(
    r"XC(?P<recordingId>\d+)_+(?P<commonName>[^_]+)_+(?P<scientificName>[^_]+)_+(?P<type>\w+)\.(wav|mp3|m4a)",
    re.IGNORECASE
)

def split_camel_case(text):
    return re.sub(r"(?<=[a-z])(?=[A-Z])", " ", text).strip()

metadata = []

for filename in os.listdir(AUDIO_DIR):
    match = FILENAME_REGEX.match(filename)
    if not match:
        print(f"Skipped unrecognized filename: {filename}")
        continue

    common_raw = match.group("commonName").replace("-", " ")
    scientific_raw = match.group("scientificName").replace("-", " ")

    common_name = split_camel_case(common_raw)
    scientific_name_parts = re.findall(r'[A-Z][a-z]*', scientific_raw)
    if len(scientific_name_parts) >= 2:
        scientific_name = f"{scientific_name_parts[0]} {scientific_name_parts[1].lower()}"
    else:
        scientific_name = split_camel_case(scientific_raw)

    bird_entry = {
        "id": f"XC{match.group('recordingId')}",
        "name": common_name,
        "scientific": scientific_name,
        "imageName": common_name.replace(" ", ""),
        "habitat": "Placeholder habitat",
        "description": "Placeholder description",
        "info": f"https://www.allaboutbirds.org/guide/{common_name.replace(' ', '_')}"
    }
    metadata.append(bird_entry)

with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
    json.dump(metadata, f, indent=2)

print(f"Generated {OUTPUT_FILE} with {len(metadata)} entries.")
