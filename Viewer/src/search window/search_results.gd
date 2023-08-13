extends Tree


# Other = [file_name, index, key, "original text"]
#		  [file_name, index, key, "cells", cell_index]
func setup(results: Dictionary):
	
	var root = create_item()
	
	for file in results.keys():
		
		var current: TreeItem = create_item(root)
		current.set_text(0, file)
		
		if file == "CommonEvents":
			pass
		elif "Map" in file:
			pass
		elif file == "System":
			pass
		else:
			setup_other(results[file], current)


func setup_other(coords: Array, parent: TreeItem):
	
	columns = 10
	
	for item in coords:
		
		#var entry = create_item(parent)
		#entry.set_text(0, str(item[1]))
		parent.set_text(1, "entry: " + str(item[1]))
		
		#var key = create_item(entry)
		#key.set_text(0, str(item[2]))
		parent.set_text(1, "key: " + str(item[2]))
		
		if len(item) > 4:
			#var cell_index = create_item(key)
			#cell_index.set_text(0, item[3])
			#parent.set_text(2, item[3])
			#		  [file_name, index, key, "cells", cell_index]
			var text = create_item(parent)
			text.set_text(0, Data.translation[item[0]][item[1]][item[2]][item[3]][item[4]]["text"])
		else:
			#var text = create_item(key)
			#text.set_text(0, Data.translation[item[0]][item[1]][item[2]][item[3]])
			pass
