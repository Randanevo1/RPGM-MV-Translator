extends Window

@onready var progress = $PanelContainer/VBoxContainer/progress
@onready var close = $PanelContainer/VBoxContainer/close
@onready var status = $PanelContainer/VBoxContainer/status
@onready var animation = $AnimationPlayer
@onready var cont = $PanelContainer


var current_count = 0
var max_count     = 0
var template_string = "Files processed: {min}/{max}"

# Called when the node enters the scene tree for the first time.
func _ready():
	Data.connect("backup_start", _on_backup_start)
	Data.connect("backup_end", _on_backup_end)
	Data.connect("save_start", _on_save_start)
	Data.connect("save_end", _on_save_end)
	Data.connect("file_processed", _on_file_proccesed)
	Data.connect("starting", _on_starting)


func _on_starting():
	var vec: Vector2i = DisplayServer.window_get_size()
	var centered = Vector2.ZERO
	centered.x = round(vec.x / 2)
	centered.y = round(vec.y / 2)
	cont.position = centered
	self.visible = true
	animation.play("fade in")


func _on_close_pressed():
	animation.play("fade out")
	await animation.animation_finished
	self.visible = false
	close.disabled = true
	progress.text = ""

#----#

func _on_backup_start(file_count: int):
	max_count     = file_count
	progress.text = template_string.format({"min":current_count, "max":max_count})
	status.text   = "Backing up files"


func _on_backup_end():
	status.text = "Finished backup"

#----#

func _on_save_start(file_count: int):
	max_count    += file_count
	progress.text = template_string.format({"min":current_count, "max":max_count})
	status.text   = "Saving"


func _on_save_end():
	close.disabled = false
	status.text    = "Finished"
	current_count  = 0
	max_count      = 0

#----#

func _on_file_proccesed():
	current_count += 1
	progress.text = template_string.format({"min":current_count, "max":max_count})
