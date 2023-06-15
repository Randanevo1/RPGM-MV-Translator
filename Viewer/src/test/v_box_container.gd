extends VBoxContainer

@onready var pages = $HBoxContainer2/ScrollContainer/PanelContainer/pages

@onready var file = $HBoxContainer/tool_bar/HBoxContainer/file
@onready var file_container = $HBoxContainer2/file_container




var data
var current_info = {"file":"", "id":9999}


func _on_file_dat():
	data = file.d
	var na   = file.n
	current_info["file"] = na
	#pages.setup_page(data[0]["pages"])
	file_container.setup_tree([[na, len(data)]])


func _on_file_container_selected_entry(dict: Dictionary):
	if dict["file"] == current_info["file"]:
		
		if dict["id"] != current_info["id"]:
			pages.clear()
			pages.setup_page(data[dict["id"]]["pages"])
		
	current_info["file"] = dict["file"]
	current_info["id"]   = dict["id"]
