extends Area2D

@export var speed: float = 300.0          # Bullet speed
@export var damage: int = 5               # Damage dealt to the target
@export var impact_effect: PackedScene    # Optional: Visual effect on hit

var target: Node2D = null                 # The target the bullet is tracking


func _process(delta):
	if target and is_instance_valid(target):
		_move_toward_target(delta)
	else:
		queue_free()  # Destroy bullet if target is gone


func _move_toward_target(delta):
	var direction = (target.global_position - global_position).normalized()
	position += direction * speed * delta
	
	# Check for collision with the target
	if global_position.distance_to(target.global_position) < 10:
		_hit_target()


func _hit_target():
	if target and target.has_method("apply_damage"):
		target.apply_damage(damage)

	# Spawn impact effect if assigned
	if impact_effect:
		var effect = impact_effect.instantiate()
		effect.global_position = global_position
		get_tree().current_scene.add_child(effect)

	queue_free()  # Destroy bullet after hitting the target
	
func _on_body_entered(body):
	if body == target and body.has_method("apply_damage"):
		body.apply_damage(damage)
		queue_free()
