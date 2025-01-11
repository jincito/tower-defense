extends CharacterBody2D


@export var soldier_path: PathFollow2D
@export var speed = 100
var Health = 10
#@onready var path_follow_2d = $".."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	soldier_path.set_progress(soldier_path.get_progress() + speed*delta)
	if get_parent().get_progress_ratio() == 1:
		queue_free()
