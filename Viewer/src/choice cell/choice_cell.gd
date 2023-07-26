extends VBoxContainer
class_name ChoiceCell

@onready var choice_edit = preload("res://src/choice edit/choice_edit.tscn")


func create_choices(choice_shard: Dictionary, cell_target := -1) -> void:
	
	if cell_target == -1:
		
		for og_choice in len(choice_shard["original text"]):
			
			var og_txt: ChoiceEdit = choice_edit.instantiate()
			og_txt.text = choice_shard["original text"][og_choice].c_escape()
			og_txt.editable = false
			self.add_child(og_txt)
	
	else:
		
		var choice_index = 0
		
		
		if choice_shard["cells"][cell_target]["text"][0] != null:
			
			for c_choice in choice_shard["cells"][cell_target]["text"]:
				
				var choice: ChoiceEdit = choice_edit.instantiate()
				
				choice.text = c_choice.c_escape()
				choice.choice_index = choice_index
				choice.choice_cell  = choice_shard["cells"][cell_target]
				choice_index += 1
				
				self.add_child(choice)
		
		else:
			
			for c_choice in len(choice_shard["original text"]):
				
				var choice: ChoiceEdit = choice_edit.instantiate()
				
				choice.text = ""
				choice.choice_index = choice_index
				choice.choice_cell  = choice_shard["cells"][cell_target]
				choice_index += 1
				
				self.add_child(choice)
