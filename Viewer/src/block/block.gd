extends PanelContainer
class_name Block

@onready var line_instance = preload("res://src/line/line.tscn")
@onready var id = $VBoxContainer/expand_container/id
@onready var lines = $VBoxContainer/lines_margin/lines
@onready var lines_margin = $VBoxContainer/lines_margin

var id_tex

func setup_lines(lines_arr: Array, block_name: String) -> void:
	
	id.text = block_name
	
	var line_count = 0
	
	for line in lines_arr:
		var new_line: c_line = line_instance.instantiate()
		lines.add_child(new_line)
		lines.add_child(HSeparator.new())
		new_line.code.text       = str(line["code"])
		new_line.indent.text     = str(line["indent"])
		new_line.parameters.text = str(line["parameters"])
		new_line.id.text         = "line" + str(line_count)
		line_count += 1


func _on_expand_container_request_expand():
	if lines_margin.visible == true:
		lines_margin.visible = false
	else:
		lines_margin.visible = true
