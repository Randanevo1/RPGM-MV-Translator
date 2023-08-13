extends SpinBox


# Called when the node enters the scene tree for the first time.
func _ready():
	self.value = float(Options.options["autosave time"])


func _on_value_changed(time):
	Options.change_autosave_time(time)
