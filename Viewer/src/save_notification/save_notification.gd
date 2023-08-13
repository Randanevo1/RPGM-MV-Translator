extends PanelContainer

@onready var label: Label = $HBoxContainer/Label
@onready var timer: Timer = $Timer
@onready var animation = $AnimationPlayer
@onready var global_y  = self.global_position.y
@onready var cooldown: Timer = $cooldown


# Called when the node enters the scene tree for the first time.
func _ready():
	Data.connect("save_end", pop)


func pop():
	
	if cooldown.is_stopped() == true:
		animation.play("fade in")
		timer.start(3)
		cooldown.start(3.3)


func _on_timer_timeout():
	animation.play_backwards("fade in")
