extends LineEdit
class_name ChoiceEdit

var choice_cell: Dictionary
var choice_index: int
@onready var clipboard: SetClipboard = $clipboard


func _on_text_changed(new_text: String):
	
	if len(choice_cell["text"]) - 1 < choice_index:
		choice_cell["text"].append(new_text.c_unescape())
	else:
		choice_cell["text"][choice_index] = new_text.c_unescape()


func _on_clipboard_request_set_slipboard():
	clipboard.set_clipboard(self.text)
