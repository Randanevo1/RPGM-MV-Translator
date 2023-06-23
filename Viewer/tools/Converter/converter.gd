extends Node
class_name Converter

const cell_template = {"text":[null], "cell name":"TL"}


func convert_data() -> void:
	
	var converted_dir = DirAccess.open("./" + Data.game_name)
	converted_dir.make_dir("converted data")
	var dir_path = "./" + Data.game_name + "/" + "converted data" + "/"
	
	
	for file in Data.files:
		var new_file = FileAccess.open(dir_path + file + ".json", FileAccess.WRITE)
		
		if file == "CommonEvents":
			new_file.store_line(JSON.stringify(id_looper(Data.files[file], ce_handler)))
		elif "Map" in file:
			new_file.store_line(JSON.stringify(id_looper(Data.files[file], map_handler)))
		elif file == "System":
			new_file.store_line(JSON.stringify(system_handler(Data.files[file])))
		else:
			new_file.store_line(JSON.stringify(id_looper(Data.files[file], others_handler)))

##--------------------------------------------------------##

func id_looper(entry_array: Array, entry_handler: Callable) -> Array:
	
	var converted_data = []
	
	for entry in entry_array:
		if entry != null:
			var data = entry_handler.call(entry)
			if data != {}:
				converted_data.append(data)
	
	return converted_data

##--------------------------------------------------------##
## Handlers ##

func others_handler(entry: Dictionary) -> Dictionary:
	
	var chunk = {"id":entry["id"]}
	for key in entry.keys():
		if key != "id":
			chunk[key] = {"original text":entry[key], "cells":[{"text":null, "cell_name":""}]}
	return chunk


func map_handler(entry: Dictionary):
	
	var converted_entry = {"id":entry["id"], "pages":[]}
	
	var holder = []
	for page in entry["pages"]:
		
		for block in page["list"]:
			
			holder.append(convert_block(block))
		converted_entry["pages"].append({"list":holder})
	
	for new_page in converted_entry["pages"]:
		for new_block in new_page["list"]:
			if len(new_block) > 0:
				return converted_entry
	return {}


func ce_handler(entry: Dictionary) -> Dictionary:
	var converted_entry = {"id":entry["id"], "list":[]}
	
	for block in entry["list"]:
		converted_entry["list"].append(convert_block(block))
	
	for new_block in converted_entry["list"]:
		if len(new_block) > 0:
			return converted_entry
		
	return {}


func system_handler(sys_data: Dictionary) -> Dictionary:
	
	var converted = {
		"gameTitle": {"original text":sys_data["gameTitle"], "cells":[cell_template]},
		"skillTypes":  arr_looper(sys_data["skillTypes"]),
		"weaponTypes": arr_looper(sys_data["weaponTypes"]),
		"equipTypes":  arr_looper(sys_data["equipTypes"]),
		"armorTypes":  arr_looper(sys_data["armorTypes"]),
		"elements":    arr_looper(sys_data["elements"]),
		"basic":       arr_looper(sys_data["terms"]["basic"]),
		"commands":    arr_looper(sys_data["terms"]["commands"]),
		"params":      arr_looper(sys_data["terms"]["params"]),
		"messages": {}
	}
	
	for key in sys_data["terms"]["messages"]:
		var converted_key = {"original text":sys_data["terms"]["messages"][key], "cells":[{"text":null, "cell_name":""}]}
		converted["messages"][key] = converted_key
	
	return converted


func arr_looper(arr: Array):
	
	var converted_arr = []
	
	for value in arr:
		converted_arr.append({"original text":value, "cells":[{"text":null, "cell_name":""}]})
	return converted_arr

##--------------------------------------------------------##

func convert_block(block: Array):
	
	var converted_block = []
	
	var chunk = {"original text":[], "info":{"code":-1, "indent":0}, "cells":[cell_template]}
	
	for line in block:
		
		if Extractor.valid_codes.has(int(line["code"])):
			
			if int(chunk["info"]["code"]) != int(line["code"]) and chunk["info"]["code"] != -1:
				
				converted_block.append(chunk)
				chunk = {"original text":[], "info":{"code":0, "indent":0}, "cells":[cell_template]}
			
			chunk["info"]["code"]   = int(line["code"])
			chunk["info"]["indent"] = int(line["indent"])
			
			if line["code"] == 102:
				for choice in line["parameters"][0]:
					chunk["original text"].append(choice)
				chunk["info"]["misc"] = line["parameters"].slice(1)
			else:
				chunk["original text"].append(line["parameters"][0])
		
	if len(chunk["original text"]) > 0:
		converted_block.append(chunk)
	return converted_block
