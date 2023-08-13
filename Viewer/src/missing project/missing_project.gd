extends VBoxContainer

@onready var notif = $notif
@onready var path = $path
@onready var panel_container = $PanelContainer

var missing_project


signal request_select_fix
signal request_remove


func setup(project: String):
	
	missing_project = project
	notif.text = "MISSING PROJECT: " + project
	path.text = "LAST KNOWN LOCATION: " + Data.projects[project]["path"]


func _on_remove_button_up():
	panel_container.visible = true


func _on_select_button_up():
	emit_signal("request_select_fix", missing_project)


func _on_yes_button_up():
	Data.projects.erase(missing_project)
	Data.save_projects()
	Data.emit_signal("new_project")


func _on_no_button_up():
	panel_container.visible = false
