extends Node2D

const SPEED = 500

func _process(delta: float) -> void:
	# For input-controlled vertical movement (e.g., Up/Down arrows or W/S)
	#var vertical_axis = Input.get_axis("up", "down")
	#position.y += vertical_axis * SPEED * delta

	# For automatic constant downward movement (remove input lines above)
		position.y += SPEED * delta
	
	# For automatic upward movement, use:
	# position.y -= SPEED * delta
