extends VBoxContainer

@onready var file_result_cont = preload("res://src/search results/file_result.tscn")

signal request_jump

func setup_results(results):
	
	for file in results.keys():
		
		var file_results = file_result_cont.instantiate()
		self.add_child(file_results)
		file_results.setup_results(results[file])
		

func clear():
	
	for child in self.get_children():
		child.free()
	return
