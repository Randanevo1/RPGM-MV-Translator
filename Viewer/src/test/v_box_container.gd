extends VBoxContainer

@onready var pages: Page = $ScrollContainer/pages
@onready var file = $HBoxContainer/tool_bar/HBoxContainer/file


func _on_file_dat():
	var data = file.d
	pages.setup_page(data[0]["pages"])
