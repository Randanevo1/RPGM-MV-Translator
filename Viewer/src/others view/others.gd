extends PanelContainer
class_name Others_view

@onready var main_cont    = $ScrollContainer/main_cont
@onready var others_entry = preload("res://src/others view/others_entry.tscn")


func setup_view(entries: Array):
	
	var entry_count = 0
	
	for entry in entries:
		var new_entry: Others_entry = others_entry.instantiate()
		main_cont.add_child(new_entry)
		
		new_entry.id.text = "entry" + str(entry_count)
		new_entry.setup_entry(entry)
		
		entry_count += 1


func clear():
	
	for child in main_cont.get_children():
		child.free()
