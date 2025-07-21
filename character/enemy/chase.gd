extends State

@export var idle_state: State
@export var attack_state: State

func enter() -> void:
	parent.state = parent.States.CHASE
	print("enemy chasing")

func process_physics(delta: float) -> State:
	parent.pointer.global_position = Player.global_position
	parent.navigation_agent.target_position = Player.global_position
	parent.direction = (parent.pointer.global_position - parent.position).normalized()
	return null
	
func process_frame(delta: float) -> State:
	if !parent.player_in_range:
		return idle_state
	if parent.in_attack_range:
		return attack_state
	return null
