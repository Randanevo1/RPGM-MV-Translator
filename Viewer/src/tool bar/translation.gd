extends MenuButton

@onready var proj_select = $proj_select
@onready var apply_progress_tracker = $apply_progress_tracker



signal translating
signal saving
signal error

func _ready():
	self.get_popup().connect("id_pressed", button_selected)


func button_selected(id):
	
	match id:
		0:
			#proj_select.show()
			#project_selector.visible = true
			pass
		1:
			if Data.translation.is_empty() != true:
				apply_progress_tracker.visible = true
				DeConverter.de_convert()


func _on_proj_select_dir_selected(dir: String):
	
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
		Data.projects[game_name] = {"path":dir}
		Data.emit_signal("new_project")
	
	Data.open_project(dir)


func _on_project_selector_error(err_string: String):
	emit_signal("error", err_string)
