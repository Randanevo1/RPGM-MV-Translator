extends HBoxContainer


@onready var button = $Button
signal button_up

func set_text(txt):
	button.text = txt


func _on_button_button_up():
	emit_signal("button_up")
