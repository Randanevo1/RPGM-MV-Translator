extends Control
class_name c_line

@onready var code:       Label = $VBoxContainer2/MarginContainer/main_cont/code.value
@onready var indent:     Label = $VBoxContainer2/MarginContainer/main_cont/indent.value
@onready var parameters: Label = $VBoxContainer2/MarginContainer/main_cont/parameters.value
@onready var main_cont = $VBoxContainer2/MarginContainer/main_cont
@onready var id = $VBoxContainer2/expand_container/id


var line_dict: Dictionary


func _on_expand_container_request_expand():
	if main_cont.visible == true:
		main_cont.visible = false
	else:
		main_cont.visible = true