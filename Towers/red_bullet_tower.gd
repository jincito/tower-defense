extends StaticBody2D

@export var bullet_scene: PackedScene = preload("res://Towers/red_bullet.tscn")
@export var bullet_damage: int = 5
@export var targeting_range: float = 100.0
@export var target_priority: String = "nearest"

@onready var shoot_timer = Timer.new()
@onready var detection_area = $Area2D  # Ensure the node is named correctly in the scene

var curr_targets: Array = []
var curr_target: Node2D = null

func _ready():
	shoot_timer.wait_time = 1.0
	shoot_timer.autostart = true
	shoot_timer.one_shot = false
	add_child(shoot_timer)
	shoot_timer.connect("timeout", Callable(self, "_shoot"))

	if detection_area:
		detection_area.connect("body_entered", Callable(self, "_on_tower_body_entered"))
		detection_area.connect("body_exited", Callable(self, "_on_tower_body_exited"))
	else:
		print("Error: Area2D node not found!")

func _on_tower_body_entered(body):
	if body.is_in_group("Enemies"):
		curr_targets.append(body)
		_update_target()

func _on_tower_body_exited(body):
	if body in curr_targets:
		curr_targets.erase(body)
		_update_target()

func _update_target():
	if curr_targets.is_empty():
		curr_target = null
		return
	
	match target_priority:
		"nearest":
			curr_target = _get_nearest_target()
		"strongest":
			curr_target = _get_strongest_target()
		"weakest":
			curr_target = _get_weakest_target()
		_:
			curr_target = _get_nearest_target()

func _get_nearest_target():
	var nearest = curr_targets[0]
	var min_distance = position.distance_to(nearest.position)
	for target in curr_targets:
		var distance = position.distance_to(target.position)
		if distance < min_distance:
			min_distance = distance
			nearest = target
	return nearest

func _get_strongest_target():
	var strongest = curr_targets[0]
	for target in curr_targets:
		if target.current_health > strongest.current_health:
			strongest = target
	return strongest

func _get_weakest_target():
	var weakest = curr_targets[0]
	for target in curr_targets:
		if target.current_health < weakest.current_health:
			weakest = target
	return weakest

func _shoot():
	if curr_target and is_instance_valid(curr_target):
		var bullet = bullet_scene.instantiate()
		bullet.global_position = global_position
		bullet.target = curr_target
		bullet.damage = bullet_damage
		get_tree().current_scene.add_child(bullet)
