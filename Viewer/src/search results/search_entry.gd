extends PanelContainer


@onready var coords_view: Label = $HBoxContainer/VBoxContainer/coords
@onready var text: Label = $HBoxContainer/VBoxContainer/text



var ce_format_str    = "CommonEvents, Event: {0}, Column: {1}"
var map_format_str   = "{0}, Event: {1}, Column: {2}"
var other_format_str = "{0}, Column: {1}"
var sys_format_str   = "System, Key: {0}, Column: {1}"


var jump_data

func setup(txt, coords, _file_name):
	jump_data = coords
	text.text = txt
	
	if coords[0] == "CommonEvents":
		coords_view.text = ce_format_str.format([coords[1], coords[5]])
	elif "Map" in coords[0]:
		coords_view.text = map_format_str.format([coords[0], coords[1], len(coords) - 1])
	elif coords[0] == "System":
		coords_view.text = sys_format_str.format([coords[1], len(coords) - 1])
	else:
		coords_view.text = other_format_str.format([coords[0], len(coords) - 1])


func _on_jump_to_button_up():
	Data._request_jump(jump_data)
