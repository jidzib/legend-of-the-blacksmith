extends Node

class_name State

var parent

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null

#func update_raycast() -> void:
	## raycast handling
	#var dir_vector = Vector2.ZERO
	#match parent.current_dir:
		#Vector2.RIGHT: dir_vector = Vector2.RIGHT
		#Vector2.LEFT: dir_vector = Vector2.LEFT
		#Vector2.UP: dir_vector = Vector2.UP
		#Vector2.DOWN: dir_vector = Vector2.DOWN
	#parent.raycast.target_position = dir_vector * parent.raycast_length
	#parent.raycast.enabled = true
		
