extends VBoxContainer

@onready var pages: Page = $HBoxContainer2/ScrollContainer/PanelContainer/pages
@onready var file = $HBoxContainer/tool_bar/HBoxContainer/file
@onready var file_container: File_list = $HBoxContainer2/file_container
@onready var system: System_view = $HBoxContainer2/ScrollContainer2/system

@onready var page_cont = $HBoxContainer2/ScrollContainer
@onready var sys_cont  = $HBoxContainer2/ScrollContainer2

var data
var current_info = {"file":"", "id":9999, "key":""}


func _on_file_container_selected_entry(dict: Dictionary):
	if dict["file"] == "System":
		sys_cont.visible = true
		page_cont.visible  = false
		
		system.clear()
		system.setup_view(dict["key"])
		current_info["key"] = dict["key"]
	
	elif dict["id"] != current_info["id"] or dict["file"] != current_info["file"]:
		sys_cont.visible = false
		page_cont.visible  = true
		
		pages.clear()
		pages.setup_page(Data.files[dict["file"]][dict["id"]]["pages"])
		current_info["id"]   = dict["id"]
	
	current_info["file"] = dict["file"]
	


func _on_file_extracted_game():
	file_container.setup_tree(Data.files.keys())
