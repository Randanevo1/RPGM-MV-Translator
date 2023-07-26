extends MenuButton

@onready var proj_select = $proj_select

signal translating

func _ready():
	self.get_popup().connect("id_pressed", button_selected)


func button_selected(id):
	
	match id:
		0:
			proj_select.show()
		2:
			Data.save_translation()


func _on_proj_select_dir_selected(dir):
	
	var conv_dir_path = dir + "/" + "converted data"
	var conv_dir = DirAccess.open(conv_dir_path)
	Data.current_dir = conv_dir_path
	
	for file in conv_dir.get_files():
		var file_name = file.split(".")[0]
		var data = FileAccess.open(conv_dir_path + "/" + file, FileAccess.READ).get_as_text()
		var contents = JSON.parse_string(data)
		Data.translation[file_name] = contents
		Data.file_info[file_name]   = len(contents)
	emit_signal("translating")


func save():
	pass
