extends PanelContainer

signal translating
signal extracted_game

@onready var warning = $Warning
@onready var file = $HBoxContainer/file
@onready var project_selector = $project_selector



func _on_translation_translating():
	emit_signal("translating")


func _on_file_extracted_game():
	emit_signal("extracted_game")


func warn_usr(err: String):
	warning.set_warning(err)
	warning.visible = true


func _on_file_error(err_msg: String):
	warn_usr(err_msg)


func _on_translation_error(err_msg: String):
	warn_usr(err_msg)


func _on_project_selector_error(err_msg: String):
	warn_usr(err_msg)


func _on_project_selector_request_extract(dir):
	file._on_file_select_dir_selected(dir)


func _on_file_request_project_select():
	project_selector.visible = true
