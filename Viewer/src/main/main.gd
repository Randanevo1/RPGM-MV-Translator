extends Control

@onready var file_select: FileSelect = $VBoxContainer/HBoxContainer/file_select
@onready var list_view   = $VBoxContainer/HBoxContainer/list_view
@onready var others_view = $VBoxContainer/HBoxContainer/others_view
@onready var autosave: Timer = $autosave
@onready var animation_player = $VBoxContainer/HBoxContainer/AnimationPlayer
@onready var search_window = $search_window


var current_node

var node_list = []

func _ready():
	
	node_list = [list_view, others_view]
	Data.connect("request_jump", on_request_jump)
	Data.connect("translating", _on_translating)


func on_request_jump(jump_coords):
	
	var file_name = jump_coords[0]
	var file
	
	
	
	if "Map" in file_name:
		file = {"file":file_name, "type":FileType.type.Map, "id":jump_coords[1]}
	elif file_name == "CommonEvents":
		file = {"file":file_name, "type":FileType.type.CommonEvents, "id":jump_coords[1]}
	elif file_name == "System":
		file = {"file":file_name, "key":jump_coords[1], "type":FileType.type.System}
	else:
		file = {"file":file_name, "type":FileType.type.Other}
	setup_list(file)


func _on_file_select_selected_entry(file):
	setup_list(file)


func setup_list(file):
	
	match file["type"]:
		
		FileType.type.Map:
			others_view.visible = false
			list_view.visible = false
			current_node = list_view
			await list_view.clear()
			list_view.setup_list_view(Data.translation[file["file"]][file["id"]]["pages"], file["type"], file["id"])
			list_view.visible = true
		
		FileType.type.CommonEvents:
			#await fade(list_view)
			others_view.visible = false
			list_view.visible = false
			current_node = list_view
			await list_view.clear()
			list_view.setup_list_view(Data.translation["CommonEvents"][file["id"]]["list"], file["type"], file["id"])
			list_view.visible = true
			#unfade()
		
		FileType.type.System:
			#await fade(others_view)
			others_view.visible = false
			list_view.visible = false
			current_node = others_view
			await others_view.clear()
			others_view.setup_others_view(Data.translation[file["file"]][file["key"]], file["type"])
			others_view.visible = true
			#unfade()
		
		FileType.type.Other:
			#await fade(others_view)
			others_view.visible = false
			list_view.visible = false
			current_node = others_view
			await others_view.clear()
			others_view.setup_others_view(Data.translation[file["file"]], file["type"])
			others_view.visible = true
			#unfade()


func _on_translating():
	file_select.setup_tree(Data.translation.keys(), Data.translation)
	animation_player.play("fade cont")
	autosave.start(Options.options["autosave time"])


func toggle_vis(node):
	
	if node.name == "list_view":
		others_view.visible = false
		list_view.visible = true
	else:
		list_view.visible = false
		others_view.visible = true


func fade(node):
	
	if current_node == node:
		
		if node == list_view:
			animation_player.play("fade list")
		else:
			animation_player.play("fade other")
	
	else:
		
		if node == others_view:
			animation_player.play("fade list")
		else:
			animation_player.play("fade other")
	
	await animation_player.animation_finished
	return


func unfade():
	
	if current_node == list_view:
		animation_player.play("unfade list")
	else:
		animation_player.play("unfade other")


func _on_search_button_request_search():
	search_window.visible = true
