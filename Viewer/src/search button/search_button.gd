extends TextureButton

signal request_search

func _on_pressed():
	emit_signal("request_search")
