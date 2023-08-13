extends Control

@onready var text_entry: LineEdit = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/text_entry
#@onready var search_results: Tree = $PanelContainer/MarginContainer/VBoxContainer/search_results
@onready var whole_word: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/whole_word
@onready var case_sensitive: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/case_sensitive
@onready var search_results = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/PanelContainer/search_results2


var conditions = {
	"whole word":false,
	"case sens":false
}


var current_search

# very cool thing
func _on_text_entry_text_submitted(new_text):
	
	await search_results.clear()
	
	var results = Find.search(new_text, conditions)
	current_search = results
	search_results.setup_results(results)


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


func _on_close_pressed():
	self.visible = false


func _on_whole_word_toggled(button_pressed):
	conditions["whole word"] = button_pressed


func _on_case_sensitive_toggled(button_pressed):
	conditions["case sens"] = button_pressed


func _on_clear_entry_pressed():
	text_entry.text = ""


func _on_clear_button_up():
	search_results.clear()
