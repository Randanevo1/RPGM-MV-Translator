extends Node

var valid_codes = [
	401,
	405,
	102,
	356,
	108
]

signal started_extraction
signal extracted_file
signal extraction_end


func send_signal(signal_name: String, f_len := 0):
	
	if f_len != 0:
		emit_signal(signal_name, f_len)
	else:
		emit_signal(signal_name)


##--------------------------------------------------------##

func extract(data, file_name: String):
	
	var extracted
	
	if file_name in "CommonEvents":
		extracted = id_looper(data, ce_entry_handler)
	elif "Map" in file_name:
		extracted = id_looper(data, map_entry_handler)
	elif file_name in "System":
		extracted = system_handler(data)
	else:
		extracted = id_looper(data, others_entry_handler)
	emit_signal("extracted_file", file_name)
	return extracted

##--------------------------------------------------------##

func id_looper(entry_array, entry_handler: Callable) -> Array:
	
	var parsed_data = []
	
	for entry in entry_array:
		if entry != null:
			parsed_data.append(entry_handler.call(entry))
	
	return parsed_data

##--------------------------------------------------------##
## Handlers ##

func others_entry_handler(entry: Dictionary) -> Dictionary:
	var VALID_KEYS = [
	"description",
	"name",
	"nickname",
	"message1",
	"message2",
	"message3",
	"message4"
	]
	
	var parsed_data = {"id":entry["id"]}
	
	for key in VALID_KEYS:
		if key in entry:
			parsed_data[key] = entry[key]
	
	return parsed_data


func ce_entry_handler(entry: Dictionary) -> Dictionary:
	return {"id":entry["id"], "list":break_up_list(entry["list"])}


func map_entry_handler(entry: Dictionary) -> Dictionary:
	
	var data = {"id":entry["id"], "name":entry["name"], "note":entry["note"], "pages":[]}
	
	for page in entry["pages"]:
		data["pages"].append({"list":break_up_list(page["list"])})
	
	return data


func system_handler(entry: Dictionary) -> Dictionary:
	var data = {
		"gameTitle":entry["gameTitle"],
		"skillTypes": entry["skillTypes"],
		"weaponTypes": entry["weaponTypes"],
		"equipTypes": entry["equipTypes"],
		"armorTypes": entry["armorTypes"],
		"elements": entry["elements"],
		"terms": entry["terms"]
	}
	return data

##--------------------------------------------------------##

func break_up_list(list: Array) -> Array:
	
	var blocks     = []
	var tmp_holder = []
	
	for line in list:
		var tmp_hold_size = len(tmp_holder)
		
		if tmp_hold_size == 0:
			tmp_holder.append(line)
			continue
		
		if is_entry_valid(line) == true: #valid_codes.has(int(line["code"])):
			if is_tmp_holder_valid(tmp_holder) == true:
				tmp_holder.append(line)
			else:
				blocks.append(tmp_holder)
				tmp_holder = []
				tmp_holder.append(line)
		
		else:
			if is_tmp_holder_valid(tmp_holder) == false:
				tmp_holder.append(line)
			else:
				blocks.append(tmp_holder)
				tmp_holder = []
				tmp_holder.append(line)
	
	if len(tmp_holder) > 0:
		blocks.append(tmp_holder)
	
	return blocks


func is_entry_valid(entry) -> bool:
	
	
	if valid_codes.has(int(entry["code"])):
		
		if int(entry["code"]) == 108:
			if "text_indicator" in entry["parameters"][0]:
				return true
			return false
		
		elif int(entry["code"]) == 356:
			if "D_TEXT" in entry["parameters"][0] and int(entry["indent"]) == 0:
				return true
			return false
		
		return true
	
	return false


func is_tmp_holder_valid(holder: Array) -> bool:
	
	if len(holder) == 0:
		return false
	elif int(holder[0]["code"]) in valid_codes:
		return true
	return false
