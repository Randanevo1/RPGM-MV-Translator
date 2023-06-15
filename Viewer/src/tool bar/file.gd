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

@onready var file_select: NativeFileDialog = $"file_select"
var d
var n: String

signal dat

# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_popup().connect("id_pressed", button_selected)


func button_selected(id):
	
	match id:
		0:
			file_select.show()
		1:
			pass


func _on_native_file_dialog_file_selected(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	var contents = JSON.parse_string(file.get_as_text())
	
	var file_name = path.get_file().split(".")[0]

	
	if "Map" in file_name:
		if "MapInfo" in file_name:
			return
		extract_selected_file(contents["events"], file_name)
	
	for f_name in valid_files:
		if file_name in f_name:
			extract_selected_file(contents, file_name)


func extract_selected_file(data, file_name):
	d = Extractor.extract(data, file_name)
	n = file_name
	emit_signal("dat")
