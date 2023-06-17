extends PanelContainer
class_name Others_entry

@onready var main_cont = $VBoxContainer/main_cont
@onready var key_value = preload("res://src/key value row/key_value.tscn")
@onready var id        = $VBoxContainer/expand_container/id


func setup_entry(entry: Dictionary):
	
	for key in entry.keys():
		var new_kv: KeyValueRow = key_value.instantiate()
		main_cont.add_child(new_kv)
		new_kv.key.text   = key
		new_kv.value.text = str(entry[key])


func _on_expand_container_request_expand():
	
	if main_cont.visible == true:
		main_cont.visible = false
	else:
		main_cont.visible = true
