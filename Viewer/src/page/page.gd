extends TabContainer
class_name Page

@onready var block = preload("res://src/block/block.tscn")
@onready var m_vbox = preload("res://src/margin vbox/margin_vbox.tscn")
@onready var scroll = preload("res://src/scroll preset/scroll_preset.tscn")
@onready var page = $"."


func clear():
	for child in page.get_children():
		child.free()


func setup_page(page_arr: Array):
	
	var page_count = 0
	
	for pag in page_arr:
		
		var marg: M_Vbox = m_vbox.instantiate()
		var scroll_cont = scroll.instantiate()
		scroll_cont.name = "page" + str(page_count)
		page.add_child(scroll_cont)
		scroll_cont.add_child(marg)
		
		var block_count = 0
		
		for bloc in pag["list"]:
			var new_block: Block = block.instantiate()
			marg.add_to_cont(new_block)
			new_block.setup_lines(bloc, "block" + str(block_count))
			block_count += 1
		
		page_count += 1
