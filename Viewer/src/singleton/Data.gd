extends Node

var converted_dir:     String
var current_dir:       String
var game_name:         String
var file_paths:        Dictionary
var file_info:         Dictionary
var current_file_data: Dictionary
var files = {}
var translation = {}
var projects = {}

signal starting
signal file_processed

signal backup_start
signal backup_end

signal save_start
signal save_end

signal request_jump

signal translating

signal new_project

func open_project(dir):
	
	var conv_dir_path = dir + "/" + "converted data"
	var conv_dir = DirAccess.open(conv_dir_path)
	current_dir = conv_dir_path
	var split_dir = dir.split("/")
	game_name = split_dir[len(split_dir) - 1]
	
	for file in conv_dir.get_files():
		var file_name = file.split(".")[0]
		var data = FileAccess.open(conv_dir_path + "/" + file, FileAccess.READ).get_as_text()
		var contents = JSON.parse_string(data)
		translation[file_name] = contents
		file_info[file_name]   = len(contents)
	emit_signal("translating")


func save_translation():
	
	if translation.is_empty():
		return
	
	emit_signal("starting")
	
	verify_backup_folder()
	
	backup_old_files()
	
	var keys = translation.keys()
	emit_signal("save_start", len(keys))
	
	save_files(keys)


func backup_old_files():
	
	var to_save_path = current_dir + "/" + "backup"
	var cur_dir = DirAccess.open(current_dir)
	var file_con = cur_dir.get_files()
	
	emit_signal("backup_start", len(file_con))
	
	for file in file_con:
		
		var old    = current_dir  + "/" + file
		var backup = to_save_path + "/" + file
		
		cur_dir.rename(old, backup)
		emit_signal("file_processed")


func autosave():
	
	verify_backup_folder()
	
	save_files(translation.keys())


func save_files(keys: Array) -> void:
	
	for file in keys:
		
		var new_file = FileAccess.open(current_dir + "/" + file + ".json", FileAccess.WRITE)
		
		var j_string = JSON.stringify(translation[file])
		
		new_file.store_line(j_string)
		
		emit_signal("file_processed")
	
	emit_signal("save_end")


func verify_backup_folder():
	
	if DirAccess.dir_exists_absolute(current_dir + "/" + "backup") != true:
		var dir_acc = DirAccess.open(current_dir)
		dir_acc.make_dir("backup")


func _request_jump(coords):
	emit_signal("request_jump", coords)


func add_new_project(g_name, dir_path):
	
	projects[g_name] = {"path": dir_path}
	
	save_projects()
	
	emit_signal("new_project")


func save_projects():
	var file = FileAccess.open("./projects.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(projects))
