extends Node

var converted_dir:     String
var current_dir:       String
var game_name:         String
var file_paths:        Dictionary
var file_info:         Dictionary
var current_file_data: Dictionary
var files = {}
var translation = {}


func save_translation():
	
	if DirAccess.dir_exists_absolute(current_dir + "/" + "backup") != true:
		var dir_acc = DirAccess.open(current_dir)
		dir_acc.make_dir("backup")
	
	backup_old_files()
	
	for file in translation.keys():
		
		var new_file = FileAccess.open(current_dir + "/" + file + ".json", FileAccess.WRITE)
		
		var j_string = JSON.stringify(translation[file])
		
		new_file.store_line(j_string)


func backup_old_files():
	
	var to_save_path = current_dir + "/" + "backup"
	var cur_dir = DirAccess.open(current_dir)
	
	for file in cur_dir.get_files():
		
		var old    = current_dir  + "/" + file
		var backup = to_save_path + "/" + file
		
		cur_dir.rename(old, backup)
