extends CharacterBody2D

@export var soldier_path: PathFollow2D
@export var speed: float = 100.0
@export var max_health: int = 10
@export var reward: int = 5

var current_health: int

func _ready():
	current_health = max_health

func _process(delta):
	_move_along_path(delta)
	_check_goal_reached()

func _move_along_path(delta):
	if soldier_path:
		soldier_path.progress += speed * delta

func _check_goal_reached():
	if soldier_path and soldier_path.progress_ratio >= 1.0:
		_reach_goal()

func apply_damage(amount: int):
	current_health -= amount
	if current_health <= 0:
		_die()

func _die():
	emit_signal("enemy_defeated", reward)
	queue_free()

func _reach_goal():
	# Damage the player if desired
	queue_free()
