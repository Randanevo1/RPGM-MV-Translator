extends Node

#var autosave_time = 60
var options: Dictionary
var file: FileAccess
var proj_options = {}

signal changed_autosave_time


func _ready():
	
	
	if FileAccess.file_exists("./options.json") != true:
		make_file()
	
	file = FileAccess.open("./options.json", FileAccess.READ)
	
	var contents = JSON.parse_string(file.get_as_text())
	
	options = contents
	
	verify_keys()


func make_file():
	var v = FileAccess.open("./options.json", FileAccess.WRITE)
	v.store_string("{}")


func get_proj_options():
	
	var f = FileAccess.open(Data.current_dir + "/project options.json", FileAccess.READ_WRITE).get_as_text()
	proj_options = JSON.parse_string(f)


func verify_keys():
	
	if options.get("autosave time") == null:
		options["autosave time"] = 60


func change_autosave_time(time: int):
	
	options["autosave time"] = time
	var f = FileAccess.open("./options.json", FileAccess.WRITE)
	f.store_string(JSON.stringify(options))
	emit_signal("changed_autosave_time")


func save_options():
	var d_str = JSON.stringify(options)
	file.store_string(d_str)
