extends PanelContainer

@onready var main_cont = $VBoxContainer/main_cont

var entry_dict


func _on_expand_container_request_expand():
	if main_cont.visible == true:
		main_cont.visible = false
	else:
		main_cont.visible = true
