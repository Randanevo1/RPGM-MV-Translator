extends PanelContainer
class_name Common_event_view

@onready var main_cont  = $MarginContainer/ScrollContainer/MarginContainer2/main_cont
@onready var block_tscn = preload("res://src/block/block.tscn")


func setup_list(list: Array) -> void:
	
	var block_count = 0
	
	for block in list:
		var new_block: Block = block_tscn.instantiate()
		main_cont.add_child(new_block)
		new_block.setup_lines(block, "block" + str(block_count))
		block_count += 1


func clear():
	
	for child in main_cont.get_children():
		child.free()
