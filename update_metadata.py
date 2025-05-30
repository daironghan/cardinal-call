import os
import json
import re

AUDIO_DIR = "BirdCalls"
OUTPUT_FILE = "metadata.json"

# Matches: XC860679-Anna'sHummingbird-CalypteAnna-song.wav
FILENAME_REGEX = re.compile(
    r"XC(?P<recordingId>\d+)-(?P<commonName>.+?)-(?P<scientificName>.+?)-(?P<type>\w+)\.(wav|mp3|m4a)",
    re.IGNORECASE
)

def split_camel_case(text):
    return re.sub(r"(?<=[a-z])(?=[A-Z])", " ", text).strip()

metadata = []

for filename in os.listdir(AUDIO_DIR):
    match = FILENAME_REGEX.match(filename)
    if not match:
        print(f"⚠️ Skipped unrecognized filename: {filename}")
        continue

    common = split_camel_case(match.group("commonName").replace("_", " ").replace("-", " "))
    scientific = split_camel_case(match.group("scientificName").replace("_", " ").replace("-", " "))
    
    entry = {
        "title": common,
        "scientific": scientific,
        "recordingId": f"XC{match.group('recordingId')}",
        "type": match.group("type").lower(),
        "audioFilePath": os.path.join(AUDIO_DIR, filename)
    }
    metadata.append(entry)

with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
    json.dump(metadata, f, indent=2)

print(f"✅ Generated {OUTPUT_FILE} with {len(metadata)} entries.")
