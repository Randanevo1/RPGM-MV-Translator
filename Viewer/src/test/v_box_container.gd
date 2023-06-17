extends VBoxContainer


@onready var file = $HBoxContainer/tool_bar/HBoxContainer/file
@onready var file_container: File_list = $HBoxContainer2/file_container

@onready var system: System_view = $HBoxContainer2/ScrollContainer2/system
@onready var common_events: Common_event_view = $HBoxContainer2/common_events
@onready var others: Others_view = $HBoxContainer2/others
@onready var pages: Page = $HBoxContainer2/ScrollContainer/PanelContainer/pages

@onready var page_cont = $HBoxContainer2/ScrollContainer
@onready var sys_cont  = $HBoxContainer2/ScrollContainer2

var data
var current_info = {"file":"", "id":9999, "key":""}


func _on_file_container_selected_entry(dict: Dictionary):
	if dict["file"] == "System":
		sys_cont.visible   = true
		page_cont.visible  = false
		
		system.clear()
		system.setup_view(dict["key"])
		current_info["key"] = dict["key"]
	
	elif dict["id"] != current_info["id"] or dict["file"] != current_info["file"]:
		sys_cont.visible      = false
		page_cont.visible     = false
		common_events.visible = false
		others.visible        = false
		
		pages.clear()
		common_events.clear()
		others.clear()
		
		if dict["file"] == "CommonEvents":
			common_events.setup_list(Data.files[dict["file"]][dict["id"]]["list"])
			common_events.visible = true
		
		elif "Map" in dict["file"]:
			pages.setup_page(Data.files[dict["file"]][dict["id"]]["pages"])
			page_cont.visible = true
		
		else:
			others.setup_view(Data.files[dict["file"]])
			others.visible = true
		
		current_info["id"] = dict["id"]
	
	current_info["file"] = dict["file"]
	


func _on_file_extracted_game():
	file_container.setup_tree(Data.files.keys())
