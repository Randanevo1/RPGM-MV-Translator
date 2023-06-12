from json import load
import os

##--------------------------------------------------------##

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

with open("./../valid_codes.json", "r") as f:
    valid_codes = load(f)

##--------------------------------------------------------##

def extract(file_path: str):

    file_name = os.path.basename(file_path).split(".")[0]

    with open(file_path, "r", encoding="utf-8") as f:
        data = load(f)

    if file_name in "CommonEvents":
        return id_looper(data, CE_entry_handler), file_name
    
    elif "Map" in file_name:
        return id_looper(data["events"], map_entry_handler), file_name

    elif file_name in "System":
        return parse_system(data), file_name

    elif file_name in VALID_OTHERS:
        return id_looper(data, others_handler), file_name

##--------------------------------------------------------##

def id_looper(entry_array: list, entry_handler: object):
    
    parsed_data = []

    for entry in entry_array:
        if entry != None:
            parsed_data.append(entry_handler(entry))
    
    return parsed_data

##--------------------------------------------------------##
## Handlers ##

def others_handler(entry: dict):
	VALID_KEYS = [
	"description",
	"name",
	"nickname",
	"message1",
	"message2",
	"message3",
	"message4"
	]
	
	parsed_data = {"id":entry["id"]}
	
	for i in VALID_KEYS:
		if i in entry:
			parsed_data[i] = entry[i]
	
	return parsed_data


def CE_entry_handler(entry: dict):
	data = {"id":entry["id"], "list":break_up_list(entry["list"])}
	return data


def map_entry_handler(entry: dict):

    data = {"id":entry["id"], "name":entry["name"], "note":entry["note"], "pages":[]}
        
    for page in entry["pages"]:
        data["pages"].append( {"list":break_up_list(page["list"])} )
    return data


def parse_system(data: dict):
    data = {
        "gameTitle":data["gameTitle"],
        "skillTypes": data["skillTypes"],
        "weaponTypes": data["weaponTypes"],
        "equipTypes": data["equipTypes"],
        "armorTypes": data["armorTypes"],
        "elements": data["elements"],
        "terms": data["terms"]
    }
    return data

##--------------------------------------------------------##

def break_up_list(list: list) -> list:
	blocks     = []
	tmp_holder = []
	
	for line in list:
		tmp_hold_size = len(tmp_holder)
		
		if line["code"] in valid_codes:
			if tmp_hold_size > 0:
				if is_tmp_holder_valid(tmp_holder) == True:
					tmp_holder.append(line)
				else:
					blocks.append(tmp_holder)
					tmp_holder = []
					tmp_holder.append(line)
			else:
				tmp_holder.append(line)
		else:
			if tmp_hold_size > 0:
				if is_tmp_holder_valid(tmp_holder) == False:
					tmp_holder.append(line)
				else:
					blocks.append(tmp_holder)
					tmp_holder = []
					tmp_holder.append(line)
			else:
				tmp_holder.append(line)
	
	return blocks


def is_tmp_holder_valid(holder) -> bool:
    if len(holder) == 0:
        return False
    elif holder[0]["code"] in valid_codes:
        return True
    return False