extends TextureButton
class_name SetClipboard

signal request_set_slipboard


func _on_pressed():
	emit_signal("request_set_slipboard")


func set_clipboard(text: String):
	DisplayServer.clipboard_set(text)
