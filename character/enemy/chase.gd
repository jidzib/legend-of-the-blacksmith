extends State

@export var idle_state: State
@export var attack_state: State

func enter() -> void:
	parent.state = parent.States.CHASE
	print("enemy chasing")

func process_physics(delta: float) -> State:
	parent.goal = parent.navigation_agent.get_next_path_position()
	return null
	
func process_frame(delta: float) -> State:
	var noise: Vector2 = Vector2(randf_range(-30, 30), randf_range(-30, 30))
	parent.navigation_agent.target_position = Player.position + noise
	if !parent.player_in_range:
		return idle_state
	if parent.in_attack_range:
		return attack_state
	return null
