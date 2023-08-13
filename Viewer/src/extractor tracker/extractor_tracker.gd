extends Control

@onready var label = $PanelContainer/VBoxContainer/Label
@onready var progress_bar = $PanelContainer/VBoxContainer/ProgressBar
@onready var button = $PanelContainer/VBoxContainer/Button

# Called when the node enters the scene tree for the first time.
func _ready():
	Extractor.connect("started_extraction", _on_extraction_start)
	Extractor.connect("extracted_file", _on_file_extracted)
	Extractor.connect("extraction_end", _on_extraction_end)
	
	Data_converter.connect("conversion_start", _on_conversion_start)
	Data_converter.connect("converted_file", _on_converted_file)
	Data_converter.connect("conversion_end", _on_converion_end)


func _on_extraction_start(file_count: int):
	progress_bar.max_value = file_count * 2
	label.text = "Beginning extraction"


func _on_extraction_end():
	
	label.text = "Extraction finished"


func _on_file_extracted(file_name: String):
	
	label.text = "Extracted: " + file_name
	progress_bar.value += 1


func _on_conversion_start():
	
	label.text = "Beginning conversion"


func _on_converted_file(file_name: String):
	
	label.text = "Converted: " + file_name
	progress_bar.value += 1 


func _on_converion_end():
	
	label.text = "Conversion finished"
	button.visible = true


func _on_button_button_up():
	self.visible = false
