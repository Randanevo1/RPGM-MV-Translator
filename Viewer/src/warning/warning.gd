extends Control

@onready var label = $PanelContainer/VBoxContainer/Label

func set_warning(err: String):
	label.text = err


func _on_button_button_up():
	self.visible = false
