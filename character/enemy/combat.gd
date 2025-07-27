extends State

@export var idle_state: State
@export var attack_state: State

func enter() -> void:
	parent.state = parent.States.COMBAT
	if parent.attack_on_cooldown:
		parent.random_point(parent.attack_range.shape)
	print("enemy chasing")

func process_physics(delta: float) -> State:
	parent.goal = parent.navigation_agent.get_next_path_position()
	parent.direction = parent.position.direction_to(parent.goal)
	return null
	
func process_frame(delta: float) -> State:
	if !parent.attack_on_cooldown:
		var noise: Vector2 = Vector2(randf_range(-30, 30), randf_range(-30, 30))
		parent.navigation_agent.target_position = Player.position + noise
	else:
		if parent.navigation_agent.distance_to_target() <= parent.navigation_agent.target_desired_distance:
			parent.random_point(parent.attack_range.shape)
			# change dickin around movement 
	
	if !parent.player_in_range:
		return idle_state # return to origin point
	if parent.in_attack_range and !parent.attack_on_cooldown:
		return attack_state
	return null
