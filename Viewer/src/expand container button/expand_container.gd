extends HBoxContainer

signal request_expand

@onready var expand: Button = $expand
@onready var id:     Label  = $id

var entry_id: String


func _on_expand_button_up():
	emit_signal("request_expand")
	if expand.text == "+":
		expand.text = "-"
	else:
		expand.text = "+"
