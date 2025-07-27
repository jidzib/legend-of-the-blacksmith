extends State

@export var combat_state: State

func enter() -> void:
	parent.state = parent.States.IDLE
	#parent.wander_range.position = Vector2(0, 0)
	#parent.navigation_agent.target_position = parent.origin
	# generating random point to move to in the wander circle
	parent.random_point(parent.wander_range.shape)
	print("enemy idling")
	
func process_physics(delta: float) -> State:
	parent.goal = parent.navigation_agent.get_next_path_position()
	parent.direction = parent.position.direction_to(parent.goal)
	#parent.direction
	return null
	
func process_frame(delta: float) -> State:
	if parent.navigation_agent.distance_to_target() <= parent.navigation_agent.target_desired_distance:
		parent.random_point(parent.wander_range.shape)
	if parent.player_in_range:
		return combat_state
	return null

func exit() -> void:
	pass
