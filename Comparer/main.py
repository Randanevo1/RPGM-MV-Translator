import sys
import os
import pprint

VALID_OTHERS = [
    "Armors",
    "Items",
    "Actors",
    "Weapons",
    "Troops",
    "Enemies",
    "Classes",
    "States",
    "Skills"
]

##--------------------------------------------------------##

def compare(old_file_path: str, new_file_path: str):
    
    old_name = os.path.basename(old_file_path).split(".")[0]
    new_name = os.path.basename(new_file_path).split(".")[0]

    #if old_name != new_name:
    #    return


    old_data = extractor.extract(old_file_path)
    new_data = extractor.extract(new_file_path)

    if old_name in VALID_OTHERS:
        pprint.pprint(id_looper(old_data, new_data, others_handler))

##--------------------------------------------------------##
## Directory handlers


##--------------------------------------------------------##

def id_looper(old_entries: list, new_entries: list, entry_handler: object) -> list:
    
    compared_data = []

    for entry in enumerate(old_entries):
        compared_data.append(entry_handler(entry[1], new_entries[entry[0]]))

    return compared_data

##--------------------------------------------------------##
## Handlers ##
def others_handler(old_entry: dict, new_entry: dict) -> dict:
    compared = {}
    compared["diffs"] = []
    if old_entry["id"] != new_entry["id"]:
        compared["old_id"] = old_entry["id"]
        compared["new_id"] = new_entry["id"]
        compared["diffs"].append("Id mismatch")


    compared["id"] = old_entry["id"]

    for key in old_entry.keys():
        if old_entry[key] != new_entry[key]:
            compared["diffs"].append({"problem":f"Old {key} does not match New {key}", "old_text":old_entry[key], "new_text":new_entry[key]})
    return compared