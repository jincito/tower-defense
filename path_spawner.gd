extends Node2D


@onready var path = preload("res://Stage 1.tscn")

func _on_timer_timeout():
	var temp_path = path.instantiate()
	add_child(temp_path)
