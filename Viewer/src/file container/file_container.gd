extends MarginContainer
class_name File_list

@onready var tree: Tree = $ScrollContainer/tree
signal selected_entry

# file list should look like [[file_name, id_count], [file_name, id_count]]
func setup_tree(file_list: Array):
	
	var root = tree.create_item()
	tree.hide_root = true
	
	for file in file_list:
		var file_item = tree.create_item(root)
		file_item.set_text(0, file[0])
		for id in range(file[1]):
			var entry: TreeItem = tree.create_item(file_item)
			entry.set_metadata(0, {"file":file[0], "id":id})
			entry.set_text(0, "entry %03d" % id)


func _on_tree_item_mouse_selected(_position, _mouse_button_index):
	var item: TreeItem = tree.get_selected()
	print(item.get_metadata(0))
	emit_signal("selected_entry", item.get_metadata(0))
