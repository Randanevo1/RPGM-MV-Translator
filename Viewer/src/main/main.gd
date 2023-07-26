extends VBoxContainer

@onready var file_select: FileSelect = $HBoxContainer/file_select
@onready var list_view = $HBoxContainer/list_view
@onready var others_view = $HBoxContainer/others_view

var node_list = []

var h = false
var track

func _process(_delta):
	pass
	
	node_list = [list_view, others_view]
#	if h == true:
#		print(track)


func _on_file_select_selected_entry(file):
	
	match file["type"]:
		
		FileType.type.Map:
			toggle_visibilty(list_view)
			list_view.clear()
			list_view.setup_list_view(Data.translation[file["file"]][file["id"]]["pages"], file["type"])
		
		FileType.type.CommonEvents:
			toggle_visibilty(list_view)
			list_view.clear()
			list_view.setup_list_view(Data.translation["CommonEvents"][file["id"]]["list"], file["type"])
		
		FileType.type.System:
			toggle_visibilty(others_view)
			others_view.clear()
			others_view.setup_others_view(Data.translation[file["file"]][file["key"]], file["type"])
		
		FileType.type.Other:
			toggle_visibilty(others_view)
			others_view.clear()
			others_view.setup_others_view(Data.translation[file["file"]], file["type"])


func _on_tool_bar_translating():
	file_select.setup_tree(Data.translation.keys(), Data.translation)


func toggle_visibilty(node):
	
	if node.visible == false:
		node.visible = true
	
	for child in node_list:
		
		if child.name != node.name:
			child.visible = false
