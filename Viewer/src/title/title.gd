extends Label



func _on_resizer_request_resize(x_rect):
	self.custom_minimum_size.x = x_rect
