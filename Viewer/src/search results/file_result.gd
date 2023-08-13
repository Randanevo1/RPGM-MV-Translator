extends VBoxContainer

@onready var search_entry = preload("res://src/search results/search_entry.tscn")
@onready var expand_container = $expand_container
@onready var cont = $VBoxContainer

signal request_jump


func setup_results(results: Array):
	
	var file_name = results[0][0]
	expand_container.id.text = file_name
	
	for result in results:
		
		var new_entry = search_entry.instantiate()
		var txt = get_data(result)
		
		cont.add_child(new_entry)
		
		new_entry.setup(txt, result, file_name)
		var sep = HSeparator.new()
		cont.add_child(sep)


func get_data(coords):
	
	var data = Data.translation
	
	for coord in coords:
		data = data[coord]
	
	if typeof(data) == TYPE_ARRAY:
		var combined = ""
		
		for line in data:
			combined = combined + line
		data = combined
	
	return data


func _on_expand_container_request_expand():
	if cont.visible == true:
		cont.visible = false
	else:
		cont.visible = true
