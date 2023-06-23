extends MenuButton

var valid_files = [
	"Armors",
	"Items",
	"Actors",
	"Weapons",
	"Troops",
	"Enemies",
	"Classes",
	"States",
	"Skills",
	"CommonEvents",
	"System"
]

@onready var file_select:      NativeFileDialog = $"file_select"
@onready var extracted_select: NativeFileDialog = $extracted_select
@onready var convert_select = $convert_select

signal extracted_game

# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_popup().connect("id_pressed", button_selected)


func button_selected(id):
	
	match id:
		0:
			file_select.show()
		1:
			extracted_select.show()
		2:
			convert_select.show()


func _on_file_select_dir_selected(dir: String):
	var data_path = dir + "/" + "www" + "/" + "data"
	var d: DirAccess = DirAccess.open(data_path)
	var files = d.get_files()
	
	var split_dir = dir.split("/")
	
	var g_name: String = split_dir[len(split_dir) - 1]
	
	var dir_info = {}
	
	for file in files:
		var f_name = file.split(".")[0]
		dir_info[f_name] = data_path + "/" + file
	
	extract_files(dir_info, g_name)
	
	emit_signal("extracted_game")


func extract_files(paths: Dictionary, game_name: String):
	var extract_dir = "./" + game_name + "/" + "extracted data" + "/"
	var org_dir     = "./" + game_name + "/" + "original data"  + "/"
	var new_dir = DirAccess.open("./")
	
	new_dir.make_dir(game_name)
	new_dir.make_dir("./" + game_name + "/" + "extracted data")
	new_dir.make_dir("./" + game_name + "/" + "original data")
	Data.current_dir = "./" + game_name + "/" + "extracted data"
	Data.game_name = game_name
	
	for file_name in paths:
		var file = FileAccess.open(paths[file_name], FileAccess.READ)
		var contents = JSON.parse_string(file.get_as_text())
		
		var extracted_data = null
		
		if "System" in file_name or "CommonEvents" in file_name:
			extracted_data = Extractor.extract(contents, file_name)
		
		elif "Map" in file_name:
			if "MapInfo" in file_name:
				continue
			extracted_data = Extractor.extract(contents["events"], file_name)
		
		if extracted_data == null:
			for f_name in valid_files:
				if file_name in f_name:
					extracted_data = Extractor.extract(contents, file_name)
					break
		
		if extracted_data != null:
			var extract_file = FileAccess.open(extract_dir + file_name + ".json", FileAccess.WRITE)
			var org_files    = FileAccess.open(org_dir     + file_name + ".json", FileAccess.WRITE)
			
			extract_file.store_line(JSON.stringify(extracted_data))
			org_files.store_line(JSON.stringify(contents))
			
			Data.file_info[file_name] = len(extracted_data)
			Data.files[file_name] = extracted_data
	
	Data_converter.convert_data()


func _on_extracted_select_dir_selected(dir):
	var extract_dir = DirAccess.open(dir)
	var files = extract_dir.get_files()
	var split_dir = dir.split("/")
	Data.game_name = split_dir[len(split_dir) - 2]
	
	for file in files:
		var path = dir + "/" + file
		var contents = JSON.parse_string(FileAccess.open(path, FileAccess.READ).get_as_text())
		var file_name = file.split(".")[0]
		if "Map" or "CommonEvents" in file_name or file_name not in "System":
			Data.file_info[file_name] = len(contents)
		Data.files[file_name] = contents
	emit_signal("extracted_game")
	


func _on_convert_select_dir_selected(_dir):
	
	DeConverter.de_convert()
