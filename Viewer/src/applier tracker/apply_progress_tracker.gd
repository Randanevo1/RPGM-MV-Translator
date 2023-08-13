extends Control

@onready var status: Label = $PanelContainer/VBoxContainer/status
@onready var progress_bar: ProgressBar = $PanelContainer/VBoxContainer/ProgressBar
@onready var close = $PanelContainer/VBoxContainer/close


func _ready():
	DeConverter.connect("deconverted_file", _on_deconverted_file)
	DeConverter.connect("started_deconversion", _on_started_deconversion)
	
	Applier.connect("apply_started", _on_apply_started)
	Applier.connect("applied_file", _on_applied_file)
	Applier.connect("apply_end", _on_apply_end)


func _on_apply_end():
	status.text = "Applied translation"
	close.visible = true


func _on_applied_file(file_name: String):
	status.text = "Applied: " + file_name
	progress_bar.value += 1


func _on_apply_started():
	status.text = "Applier started"


func _on_deconverted_file(file_name: String):
	status.text = "Processed: " + file_name
	progress_bar.value += 1


func _on_started_deconversion(total_file_count: int):
	status.text = "Processing started"
	progress_bar.max_value = total_file_count


func _on_close_button_up():
	self.visible = false
	progress_bar.value = 0
