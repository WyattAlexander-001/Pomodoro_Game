extends Node2D

const SPEED = 500
var axis = 1

func _process(delta: float) -> void:
	#var axis = Input.get_axis("left","right")
	position.x += axis * SPEED * delta
