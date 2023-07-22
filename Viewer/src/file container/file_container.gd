extends MarginContainer
class_name File_list

@onready var tree: Tree = $ScrollContainer/tree
signal selected_entry


func setup_tree(files: Array):
	
	var root = tree.create_item()
	tree.hide_root = true
	
	for file in files:
		
		var file_item = tree.create_item(root)
		file_item.collapsed = true
		file_item.set_text(0, file)
		file_item.set_metadata(0, file)
		
		if file in "System":
			
			for key in Data.files["System"].keys():
				
				if key == "terms":
					for item in Data.files["System"][key].keys():
						var entry: TreeItem = tree.create_item(file_item)
						entry.set_metadata(0, {"file":file, "key":item})
						entry.set_text(0, item)
					continue
				
				var entry: TreeItem = tree.create_item(file_item)
				entry.set_metadata(0, {"file":file, "key":key})
				entry.set_text(0, key)
			continue
		
		if file in "CommonEvents" or "Map" in file:
			
			for id in Data.file_info[file]:
				
				var entry: TreeItem = tree.create_item(file_item)
				entry.set_metadata(0, {"file":file, "id":id})
				entry.set_text(0, "entry %03d" % id)
		else:
			file_item.set_metadata(0, {"file":file, "id":-1})


func _on_tree_item_mouse_selected(_position, _mouse_button_index):
	var item: TreeItem = tree.get_selected()
	if typeof(item.get_metadata(0)) == TYPE_STRING:
		return
	emit_signal("selected_entry", item.get_metadata(0))
