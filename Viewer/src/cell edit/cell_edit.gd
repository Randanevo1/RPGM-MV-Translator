extends TextEdit
class_name CellEdit

var cell_data: Dictionary
var type: FileType.type


func _on_text_changed():
	cell_data["text"] = get_lines()


func get_lines():
	
	if type == FileType.type.Other or type == FileType.type.System:
		
		return self.text
	else:
		
		var lines = []
		
		for line in get_line_count():
			
			lines.append(get_line(line))
		
		return lines


func _on_resizer_request_resize(x_rect):
	self.custom_minimum_size.x = x_rect
