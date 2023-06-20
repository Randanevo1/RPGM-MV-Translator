extends PanelContainer
class_name Others_entry

@onready var main_cont = $VBoxContainer/MarginContainer/main_cont
@onready var key_value = preload("res://src/key value row/key_value.tscn")
@onready var id        = $VBoxContainer/expand_container/id
@onready var margin_container = $VBoxContainer/MarginContainer


func setup_entry(entry: Dictionary):
	
	for key in entry.keys():
		var new_kv: KeyValueRow = key_value.instantiate()
		var sep = HSeparator.new()
		main_cont.add_child(new_kv)
		new_kv.key.text   = key
		new_kv.value.text = str(entry[key])
		main_cont.add_child(sep)


func _on_expand_container_request_expand():
	
	if margin_container.visible == true:
		margin_container.visible = false
	else:
		margin_container.visible = true
