extends PanelContainer
class_name System_view

@onready var main_cont = $MarginContainer/main_cont
@onready var key_value = preload("res://src/key value row/key_value.tscn")

func clear():
	
	for child in main_cont.get_children():
		child.free()


func setup_view(sys_key: String):
	
	if sys_key == "gameTitle":
		var new_label = Label.new()
		new_label.text = Data.files["System"][sys_key]
		main_cont.add_child(new_label)
	elif sys_key == "basic" or sys_key == "commands" or sys_key == "params":
		
		setup_list(Data.files["System"]["terms"][sys_key])
	elif sys_key == "messages":
		
		for key in Data.files["System"]["terms"][sys_key]:
			var new_kv: KeyValueRow = key_value.instantiate()
			var sep = HSeparator.new()
			main_cont.add_child(new_kv)
			new_kv.key.text = key
			new_kv.value.text = Data.files["System"]["terms"][sys_key][key]
			main_cont.add_child(sep)
	else:
		setup_list(Data.files["System"][sys_key])


func setup_list(list: Array):
	
	for value in list:
		if value == null:
			continue
		var new_label = Label.new()
		var sep = HSeparator.new()
		new_label.text = value
		main_cont.add_child(new_label)
		main_cont.add_child(sep)
