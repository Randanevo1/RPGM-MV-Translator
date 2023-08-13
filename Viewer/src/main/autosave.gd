extends Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	self.wait_time = Options.options["autosave time"]
	Data.connect("save_end", _on_save_end)
	Options.connect("changed_autosave_time", change_wait_time)


func change_wait_time():
	self.wait_time = Options.options["autosave time"]


func _on_timeout():
	self.stop()
	Data.autosave()


func _on_save_end():
	self.start(Options.options["autosave time"])
