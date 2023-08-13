extends Label


func _ready():
	var txt: String = self.text
	if Options.options.get(txt) != null:
		self.custom_minimum_size.x = Options.options[txt]


func _on_resizer_request_resize(x_rect):
	self.custom_minimum_size.x = x_rect
