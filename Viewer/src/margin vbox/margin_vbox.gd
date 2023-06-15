extends MarginContainer
class_name M_Vbox

@onready var main_cont = $VBoxContainer


func add_to_cont(to_add):
	main_cont.add_child(to_add)
