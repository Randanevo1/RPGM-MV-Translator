extends PanelContainer
class_name FileSelect

@onready var tree = $MarginContainer/ScrollContainer/Tree
var file_items := {}
signal selected_entry


func _ready():
	Data.connect("request_jump", on_jump_request)


func on_jump_request(coords):
	
	var file = coords[0]
	tree.scroll_to_item(file_items[file])
	tree.set_selected(file_items[file], 0)


func setup_tree(files: Array, file_dict: Dictionary):
	
	var root = tree.create_item()
	tree.hide_root = true
	
	for file in files:
		
		var file_item = tree.create_item(root)
		file_item.collapsed = true
		file_item.set_text(0, file)
		file_item.set_metadata(0, file)
		file_items[file] = file_item
		
		if file in "System":
			
			for key in file_dict["System"].keys():
				
				if key == "terms":
					for item in file_dict["System"][key].keys():
						var entry: TreeItem = tree.create_item(file_item)
						entry.set_metadata(0, {"file":file, "key":item})
						entry.set_text(0, item)
					continue
					
				var entry: TreeItem = tree.create_item(file_item)
				entry.set_metadata(0, {"file":file, "key":key, "type":FileType.type.System})
				entry.set_text(0, key)
			continue
			
		if file in "CommonEvents" or "Map" in file:
			
			for id in Data.file_info[file]:
				
				var entry: TreeItem = tree.create_item(file_item)
				
				if file in "CommonEvents":
					entry.set_metadata(0, {"file":file, "id":id, "type":FileType.type.CommonEvents})
				else:
					entry.set_metadata(0, {"file":file, "id":id, "type":FileType.type.Map})
				entry.set_text(0, "Event %03d" % id)
		
		else:
			file_item.set_metadata(0, {"file":file, "id":-1, "type":FileType.type.Other})


func _on_tree_item_mouse_selected(_position, _mouse_button_index):
	var item: TreeItem = tree.get_selected()
	if typeof(item.get_metadata(0)) == TYPE_STRING:
		return
	emit_signal("selected_entry", item.get_metadata(0))
