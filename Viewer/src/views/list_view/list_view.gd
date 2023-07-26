extends TabContainer

@onready var view = preload("res://src/views/view/view.tscn")
@onready var margin = preload("res://src/margin/template_margin.tscn")

# If type == CommonEvents expects list array
# If type == Map          expects page array

func setup_list_view(lists: Array, type: FileType.type):
	
	if type == FileType.type.CommonEvents:
		
		self.tabs_visible = false
		var cont = margin.instantiate()
		self.add_child(cont)
		var new_view = view.instantiate()
		
		cont.get_node("cont").add_child(new_view)
		
		new_view.setup_table(lists, type, "")
	
	else:
		
		self.tabs_visible = true
		
		var page_count = 0
		
		for page in lists:
			
			if len(page["list"]) == 1:
				if len(page["list"][0]) == 0:
					page_count += 1
					continue
			
			var new_cont = margin.instantiate()
			new_cont.name = str(page_count)
			self.add_child(new_cont)
			page_count += 1
			
			var new_view = view.instantiate()
			
			new_cont.get_node("cont").add_child(new_view)
			new_view.setup_table(page["list"], type, "")


func clear():
	
	for child in self.get_children():
		child.free()
