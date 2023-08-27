extends Button


func _input(event: InputEvent):
	
	if event.is_action("Save"):
		Data.autosave()
