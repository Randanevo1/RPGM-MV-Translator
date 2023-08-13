extends TextureButton

@onready var size_display: SpinBox   = $Resizer/VBoxContainer/Label
@onready var slider:       HSlider = $Resizer/VBoxContainer/HSlider
@onready var resizer: Popup = $Resizer

signal request_resize


func _ready():
	size_display.value = get_parent().custom_minimum_size.x


func _on_done_pressed():
	resizer.hide()
	emit_signal("request_resize", size_display.value)


func _on_pressed():
	resizer.position = self.global_position
	resizer.show()
