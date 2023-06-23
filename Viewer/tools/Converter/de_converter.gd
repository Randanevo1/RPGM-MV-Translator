extends Node


func de_convert():
	
	var converted_folder = "./" + Data.game_name +"/converted data"
	var files: Dictionary = Data.files
	var to_load = DirAccess.get_files_at(converted_folder)
	var converted_files = {}
	var de_converted_files = {}
	
	for file in to_load:
		var path = converted_folder + "/" + file
		var contents = JSON.parse_string(FileAccess.open(path, FileAccess.READ).get_as_text())
		var file_name = file.split(".")[0]
		converted_files[file_name] = contents
	
	for file in files:
		var extracted_data = files[file]
		var converted_data = converted_files[file]
		if file in "CommonEvents":
			de_converted_files[file] = id_looper(extracted_data, converted_data, ce_entry_handler)
		elif "Map" in file:
			de_converted_files[file] = id_looper(extracted_data, converted_data, map_entry_handler)
		elif file in "System":
			de_converted_files[file] = system_handler(converted_data)
		else:
			de_converted_files[file] = id_looper(extracted_data, converted_data, others_entry_handler)
	
	
	Applier.apply(de_converted_files)


##--------------------------------------------------------##

func id_looper(extracted_entry_array: Array, converted_entry_array: Array, entry_handler: Callable) -> Array:
	
	var de_converted_data = []
	
	var convert_tracker = 0
	for entry in extracted_entry_array:
		if convert_tracker > len(converted_entry_array) - 1:
			break
		
		if len(converted_entry_array[convert_tracker]) == 0:
			continue
		
		if entry["id"] == converted_entry_array[convert_tracker]["id"]:

			var data = entry_handler.call(entry, converted_entry_array[convert_tracker])
			de_converted_data.append(data)
			convert_tracker += 1
	
	return de_converted_data

##--------------------------------------------------------##
## Handlers ##

func ce_entry_handler(extract_data: Dictionary, convert_data: Dictionary):
	
	var current_block = 0
	for block in convert_data["list"]:
		var de_converted_block = de_convert_block(block)
		
		if len(de_converted_block) > 0:
			extract_data["list"][current_block] = de_converted_block
		current_block += 1
	
	return extract_data


func map_entry_handler(extract_data: Dictionary, convert_data: Dictionary):
	
	var page_track = 0
	for page in convert_data["pages"]:
		
		var current_block = 0
		
		for block in page["list"]:
			var de_converted_block = de_convert_block(block)
			
			
			if len(de_converted_block) > 0:
				extract_data["pages"][page_track]["list"][current_block].clear() 
				extract_data["pages"][page_track]["list"][current_block] = de_converted_block
			current_block += 1
		page_track += 1
	
	return extract_data


func system_handler(convert_data: Dictionary):
	
	var converted = {
		"skillTypes":  arr_looper(convert_data["skillTypes"]),
		"weaponTypes": arr_looper(convert_data["weaponTypes"]),
		"equipTypes":  arr_looper(convert_data["equipTypes"]),
		"armorTypes":  arr_looper(convert_data["armorTypes"]),
		"elements":    arr_looper(convert_data["elements"]),
		"basic":       arr_looper(convert_data["basic"]),
		"commands":    arr_looper(convert_data["commands"]),
		"params":      arr_looper(convert_data["params"]),
		"messages": {}
	}
	
	
	if len(convert_data["gameTitle"]["cells"]) > 0:
		var used_cell = false
		convert_data["gameTitle"]["cells"].reverse()
		for cell in convert_data["gameTitle"]["cells"]:
			
			if cell["text"] != null:
				converted["gameTitle"] = cell["text"]
				used_cell = true
		if used_cell == false:
			converted["gameTitle"] = convert_data["gameTitle"]["original text"]
	
	
	for key in convert_data["messages"]:
		
		var used_cell = false
		if len(convert_data["messages"][key]["cells"]) > 0:
			
			for cell in convert_data["messages"][key]["cells"]:
				if cell["text"] != null:
					converted["messages"][key] = cell["text"]
					used_cell = false
					break
			if used_cell == false:
				converted["messages"][key] = convert_data["messages"][key]["original text"]
	
	return converted


func arr_looper(arr: Array):
	
	var converted_arr = []
	
	for value in arr:
		
		var used_cell = false
		
		if len(value["cells"]) > 0:
			
			for cell in value["cells"]:
				
				if cell["text"] != null:
					used_cell = true
					converted_arr.append(cell["text"])
					break
		if used_cell == false:
			converted_arr.append(value["original text"])
	
	return converted_arr


func others_entry_handler(_extact_entry:Dictionary, converted_entry: Dictionary):
	
	var de_convert_entry = {"id":converted_entry["id"]}
	
	for key in converted_entry.keys():
		var used_cell = false
		if key != "id":
			
			if len(converted_entry[key]["cells"]) > 0:
				
				converted_entry[key]["cells"].reverse()
				for cell in converted_entry[key]["cells"]:
					
					if cell["text"] != null:
						de_convert_entry[key] = cell["text"]
						used_cell = true
						break
			
			if used_cell == false:
				de_convert_entry[key] = converted_entry[key]["original text"]
	
	return de_convert_entry

##--------------------------------------------------------##

func de_convert_block(block: Array):
	
	var holder = []
	
	for chunk in block:
		
		var used_cell = false
		chunk["cells"].reverse()
		
		for cell in chunk["cells"]:
			
			if len(cell["text"]) > 0:
				
				if cell["text"][0] != null:
					for line in cell["text"]:
						holder.append({"code":chunk["info"]["code"], "indent":chunk["info"]["indent"], "parameters":[line]})
					used_cell = true
					break
		
		if used_cell == false:
			for line in chunk["original text"]:
				holder.append({"code":chunk["info"]["code"], "indent":chunk["info"]["indent"], "parameters":[line]})
	return holder
