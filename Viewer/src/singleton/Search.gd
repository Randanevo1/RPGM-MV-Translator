extends Node
class_name Search

var lookup_arr: Array
var current_conditions: Dictionary

func search(string: String, conditions: Dictionary):
	
	current_conditions = conditions
	
	var found = {}
	
	for file in Data.translation.keys():
		
		var results := []
		
		if file == "CommonEvents":
			results = search_ce(string, Data.translation[file], file)
		elif "Map" in file:
			results = search_map(string, Data.translation[file], file)
		elif file == "System":
			results = search_sys(string, Data.translation[file], file)
		else:
			results = search_other(string, Data.translation[file], file)
		
		if len(results) != 0:
			found[file] = results
	
	return found

#----#

func search_ce(string: String, dict: Array, file_name: String):
	
	var occurences = []
	
	for event in len(dict):
		
		for list in len(dict[event]["list"]):
			
			if len(dict[event]["list"][list]) == 0:
				continue
			
			if dict[event]["list"][list][0]["original text"] == null:
				continue
			
			var og_combine = combine_lines(dict[event]["list"][list][0]["original text"])
			
			if is_text_in_string(string, og_combine) == true:
				occurences.append([file_name, event, "list", list, 0, "original text"])
			
			
			var cell_search = search_cells(dict[event]["list"][list][0]["cells"], string)
			
			if len(cell_search) > 0:
				
				for found in cell_search:
					occurences.append([file_name, event, "list", list, 0, "cells", found, "text"])
	return occurences


func search_map(string: String, dict: Array, file_name: String):
	
	var occurences = []
	
	for event in len(dict):
		
		for page in len(dict[event]["pages"]):
			
			for list in len(dict[event]["pages"][page]["list"]):
				
				if len(dict[event]["pages"][page]["list"][list]) == 0:
					continue
				
				if dict[event]["pages"][page]["list"][list][0]["original text"] == null:
					continue
				
				var og_combine = combine_lines(dict[event]["pages"][page]["list"][list][0]["original text"])
				
				if is_text_in_string(string, og_combine) == true:
					occurences.append([file_name, event, "pages", page, list, "list", 0, "original text"])
				
				
				var cell_search = search_cells(dict[event]["pages"][page]["list"][list][0]["cells"], string)
				
				if len(cell_search) > 0:
					
					for found in cell_search:
						occurences.append([file_name, event, "pages", page, list, "list", 0, "cells", found, "text"])
	
	return occurences


func search_sys(string: String, dict: Dictionary, file_name: String):
	
	var occurences = []
	
	for item in dict.keys():
		
		if item == "gameTitle":
			
			if dict[item]["original text"] == null:
				continue
			
			
			if is_text_in_string(string, dict[item]["original text"]) == true:
				occurences.append([file_name, item, "original text"])
			
			var cell_search = search_cells(dict[item]["cells"], string)
			
			if len(cell_search) > 0:
				
				for found in cell_search:
					occurences.append([file_name, item, "cells", found])
		
		elif item == "messages":
			
			for key in dict[item].keys():
				
				if dict[item][key]["original text"] == null:
					continue
				
				if is_text_in_string(string, dict[item][key]["original text"]) == true:
					occurences.append([file_name, item, key, "original text"])
				
				var cell_search = search_cells(dict[item][key]["cells"], string)
				
				if len(cell_search) > 0:
					
					for found in cell_search:
						occurences.append([file_name, item, key, "cells", found, "text"])
		
		else:
			
			for entry in len(dict[item]):
				
				if dict[item][entry]["original text"] == null:
					continue
				
				if is_text_in_string(string, dict[item][entry]["original text"]) == true:
					occurences.append([file_name, item, entry, "original text"])
			
				var cell_search = search_cells(dict[item][entry]["cells"], string)
				
				if len(cell_search) > 0:
					
					for found in cell_search:
						occurences.append([file_name, item, entry, "cells", found])
	
	return occurences


func search_other(string: String, dict: Array, file_name: String):
	
	var occurences = []
	
	for item in len(dict):
		
		for key in dict[item].keys():
			
			var info = {
				"file":file_name,
				"key":key,
				"item":item
			}
			
			if key == "id":
				continue
			
			if dict[item][key]["original text"] == null:
				continue
			
			if is_text_in_string(string, dict[item][key]["original text"]) == true:
				occurences.append([info["file"], info["item"], info["key"], "original text"])
			
			var cell_search = search_cells(dict[item][key]["cells"], string)
			
			if len(cell_search) > 0:
				
				for found in cell_search:
					occurences.append([info["file"], info["item"], info["key"], "cells", found, "text"])
	
	return occurences

#----#

func search_cells(cells: Array, string: String):
	
	var cell_occur = []
	
	for cell in len(cells):
		
		if cells[cell]["text"] != null:
			
			
			if typeof(cells[cell]["text"]) == TYPE_ARRAY:
				
				if cells[cell]["text"][0] == null:
					continue
				
				var combined = combine_lines(cells[cell]["text"])
				
				if is_text_in_string(string, combined) == true:
					cell_occur.append(cell)
			
			else:
				if is_text_in_string(string, cells[cell]["text"]) == true:
					cell_occur.append(cell)
	
	return cell_occur

#----#

func is_text_in_string(txt: String, to_search: String) -> bool:
	
	if current_conditions["case sens"] == true:
		
		if to_search.find(txt) > -1:
			return true
		else:
			return false
	else:
		if to_search.findn(txt) > -1:
				return true
		else:
			return false


func combine_lines(lines):
	
	var combined = ""
	
	for line in lines:
		combined = combined + line
	
	return combined
