extends ScrollContainer

@onready var view   = preload("res://src/views/view/view.tscn")
@onready var margin = preload("res://src/margin/template_margin.tscn")
@onready var cont   = $VBoxContainer

func setup_others_view(entry, type: FileType.type):
	
	if type == FileType.type.Other:
		
		var item_track = 0
		
		for item in entry:
			
			var new_view = view.instantiate()
			cont.add_child(new_view)
			new_view.setup_table(item, type, "object: " + str(item_track))
			item_track += 1
			
	else:
		
		var new_view = view.instantiate()
		cont.add_child(new_view)
		new_view.setup_table(entry, type)


func clear():
	
	for child in cont.get_children():
		child.free()
