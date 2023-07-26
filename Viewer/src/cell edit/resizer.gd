extends TextureButton

@onready var size_display: Label   = $Resizer/VBoxContainer/Label
@onready var slider:       HSlider = $Resizer/VBoxContainer/HSlider
@onready var resizer: Popup = $Resizer

signal request_resize


func _ready():
	slider.value      = get_parent().custom_minimum_size.x
	size_display.text = str(slider.value)


func _on_done_pressed():
	resizer.hide()
	emit_signal("request_resize", slider.value)


func _on_h_slider_value_changed(value):
	size_display.text = str(slider.value)


func _on_pressed():
	resizer.show()
