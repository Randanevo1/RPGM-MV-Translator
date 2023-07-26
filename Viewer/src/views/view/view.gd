extends PanelContainer
class_name View

@onready var main_cont = $VBoxContainer/main_cont
@onready var table = $VBoxContainer/main_cont/table
@onready var expand_container = $VBoxContainer/expand_container


# entry is either a "list" from CommonEvents/Maps or a singular entry from Other/System
func setup_table(entry, type: FileType.type, display_name := ""):
	
#	if display_name == "":
#		expand_container.visible = false
#		main_cont.visible = true
	
	expand_container.id.text = display_name
	
	table.setup_table(entry, type)


func _on_expand_container_request_expand():
	
	if main_cont.visible == true:
		main_cont.visible = false
	else:
		main_cont.visible = true
