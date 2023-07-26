extends PanelContainer

signal translating
signal extracted_game

func _on_translation_translating():
	emit_signal("translating")


func _on_file_extracted_game():
	emit_signal("extracted_game")
