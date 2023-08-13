extends Control

@onready var double_click_time: Timer = $double_click_time
@onready var proj_select = $proj_select
@onready var button_cont = $PanelContainer/MarginContainer/VBoxContainer2/HBoxContainer/ScrollContainer/button_cont
@onready var extracted_select = $extracted_select
@onready var fix_path = $fix_path



@onready var missing_project = preload("res://src/missing project/missing_project.tscn")

var current_missing_project

signal error
signal request_extract

var project_names = []
var missing_projects = []

var is_double_click = false
var projects


func _ready():
	
	Data.connect("new_project", _on_new_project)
	
	if FileAccess.file_exists("./projects.json") != true:
		create_projects_file()
	
	var j_string = FileAccess.open("./projects.json", FileAccess.READ)
	Data.projects = JSON.parse_string(j_string.get_as_text())
	check_projects()
	setup_project_list()


func check_projects():
	
	for project in Data.projects.keys():
		var proj = Data.projects[project]
		if DirAccess.dir_exists_absolute(proj["path"]) != true:
			missing_projects.append(project)


func _on_new_project():
	
	clear()
	setup_project_list()


func clear():
	
	for child in button_cont.get_children():
		child.queue_free()


func create_projects_file():
	
	var new_file = FileAccess.open("./projects.json", FileAccess.WRITE)
	new_file.store_string("{}")


func setup_project_list():
	
	if len(Data.projects.keys()) == 0:
		return
	
	project_names = Data.projects.keys()
	
	for project in Data.projects.keys():
		
		create_new_button(project)


func _on_button_pressed(project := ""):
	if double_click_time.is_stopped() == true:
		double_click_time.start(0.3)
	else:
		self.visible = false
		Data.open_project(Data.projects[project]["path"])


func _on_button_2_button_up():
	self.visible = false


func create_new_button(txt: String):
	
	var p_name = txt
	
	if p_name in missing_projects:
		
		var missing = missing_project.instantiate()
		missing.connect("request_select_fix", fix_project_path)
		button_cont.add_child(missing)
		missing.setup(p_name)
		var sep = HSeparator.new()
		button_cont.add_child(sep)
	
	else:
		var new_button := Button.new()
		new_button.button_down.connect(_on_button_pressed.bind(txt))
		
		new_button.text = p_name
		new_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
		new_button.name = p_name
		
		button_cont.add_child(new_button)
		var sep = HSeparator.new()
		button_cont.add_child(sep)


func fix_project_path(project):
	current_missing_project = project
	fix_path.show()


func _on_proj_select_dir_selected(dir):
	
	if DirAccess.dir_exists_absolute(dir + "/www"):
		emit_signal("error", "Wrong folder, must choose project folder, not game folder")
		return
	elif DirAccess.dir_exists_absolute(dir + "/converted data") != true:
		emit_signal("error", "Wrong folder, must choose project folder")
		return
	
	var dir_split = dir.split("/")
	
	var game_name = dir_split[len(dir_split) - 1]
	
	if Data.projects.has(game_name):
		Data.projects[game_name]["path"] = dir
	else:
		Data.add_new_project(game_name, dir)
	
	Data.open_project(dir)


func _on_button_button_up():
	proj_select.show()


func _on_close_button_up():
	self.visible = false


func _on_select_folder_button_up():
	proj_select.show()


func _on_new_project_button_up():
	extracted_select.show()


func _on_extracted_select_dir_selected(dir):
	self.visible = false
	emit_signal("request_extract", dir)


func _on_fix_path_dir_selected(dir):
	Data.projects.erase(current_missing_project)
	
	var missing_index = missing_projects.find(current_missing_project)
	missing_projects.remove_at(missing_index)
	
	Data.add_new_project(current_missing_project, dir)
