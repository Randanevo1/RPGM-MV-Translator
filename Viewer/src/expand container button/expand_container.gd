extends HBoxContainer

signal request_expand

@onready var expand: Button = $expand
@onready var id:     Label  = $id

var entry_id: String

# Called when the node enters the scene tree for the first time.
func _ready():
	#id.text = entry_id
	pass


func _on_expand_button_up():
	emit_signal("request_expand")
	if expand.text == "+":
		expand.text = "-"
	else:
		expand.text = "+"
