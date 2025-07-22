extends State

@export var chase_state: State

func enter() -> void:
	parent.state = parent.States.IDLE
	parent.wander_range.position = Vector2(0, 0)
	parent.wander_range.top_level = true
	# generating random point to move to in the wander circle
	parent.random_point()
	print("enemy idling")
	
func process_physics(delta: float) -> State:
	parent.goal = parent.navigation_agent.get_next_path_position()
	return null
	
func process_frame(delta: float) -> State:
	if parent.navigation_agent.distance_to_target() <= parent.navigation_agent.target_desired_distance:
		parent.random_point()
	if parent.player_in_range and !parent.attack_on_cooldown:
		return chase_state
	return null

func exit() -> void:
	parent.wander_range.top_level = false
