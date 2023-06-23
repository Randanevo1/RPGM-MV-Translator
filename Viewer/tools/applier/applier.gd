extends Node


func apply(files_to_apply: Dictionary):
	
	var org_path = "./" + Data.game_name + "/original data/"
	var original_files_dir = DirAccess.open(org_path)
	
	
	var org_files = {}
	for file in original_files_dir.get_files():
		var file_name = file.split(".")[0]
		var loaded = FileAccess.open(org_path + file_name + ".json", FileAccess.READ)
		var contents = JSON.parse_string(loaded.get_as_text())
		
		org_files[file_name] = contents
	
	var dir = DirAccess.open("./" + Data.game_name)
	dir.make_dir("applied data")
	
	var applied_dir = "./" + Data.game_name + "/applied data/"
	
	for file in files_to_apply:
		var save_as = file + ".json"
		
		var data
		if file in "CommonEvents":
			data = id_looper(org_files[file], files_to_apply[file], ce_entry_handler)
		elif "Map" in file:
			var h = id_looper(org_files[file]["events"], files_to_apply[file], map_entry_handler)
			data = org_files[file]
		elif file in "System":
			data = system_handler(org_files[file], files_to_apply[file])
		else:
			data = id_looper(org_files[file], files_to_apply[file], others_entry_handler)
		
		
		var new_file = FileAccess.open(applied_dir + save_as, FileAccess.WRITE)
		new_file.store_line(JSON.stringify(data))

##--------------------------------------------------------##

func id_looper(org_array: Array, tl_array: Array, entry_handler: Callable) -> Array:
	
	var entry_tracker = 0
	for entry in org_array:
		if entry != null:
			if entry_tracker > len(tl_array) - 1:
				break
			
			if entry["id"] == tl_array[entry_tracker]["id"]:
				entry = entry_handler.call(entry, tl_array[entry_tracker])
				entry_tracker += 1

	return org_array

##--------------------------------------------------------##
## Handlers ##

func others_entry_handler(org_entry: Dictionary, tl_entry: Dictionary) -> Dictionary:
	
	for key in tl_entry.keys():
		if key != "id":
			org_entry[key] = tl_entry[key]
	
	return org_entry


func ce_entry_handler(org_entry: Dictionary, tl_entry: Dictionary) -> Dictionary:
	
	org_entry["list"] = merge_blocks(tl_entry["list"])
	
	return org_entry


func map_entry_handler(org_entry: Dictionary, tl_entry: Dictionary) -> Dictionary:
	
	var page_track = 0
	
	for page in org_entry["pages"]:
		
		page["list"] = merge_blocks(tl_entry["pages"][page_track]["list"])
		page_track += 1
	
	return org_entry


func system_handler(org_entry: Dictionary, tl_entry: Dictionary) -> Dictionary:
	
	org_entry["gameTitle"] = tl_entry["gameTitle"]
	org_entry["skillTypes"] = tl_entry["skillTypes"]
	org_entry["weaponTypes"] = tl_entry["weaponTypes"]
	org_entry["equipTypes"] = tl_entry["equipTypes"]
	org_entry["armorTypes"] = tl_entry["armorTypes"]
	org_entry["elements"] = tl_entry["elements"]
	org_entry["terms"]["basic"] = tl_entry["basic"]
	org_entry["terms"]["commands"] = tl_entry["gameTitle"]
	org_entry["terms"]["params"] = tl_entry["gameTitle"]
	org_entry["terms"]["messages"] = tl_entry["gameTitle"]
	
	return org_entry

##--------------------------------------------------------##

func merge_blocks(blocks: Array):
	
	var merged = []
	
	for block in blocks:
		
		for line in block:
			merged.append(line)
	
	return merged
