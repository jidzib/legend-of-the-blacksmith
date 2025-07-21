extends State

@export var idle_state: State
var target: Vector2

func enter() -> void:
	parent.state = parent.States.FLEE
	parent.speed = 250
	target = parent.state_machine.starting_state.random_point()
	parent.navigation_agent.target_position = parent.state_machine.starting_state.random_point()
	print("enemy fleeing")
	
func process_physics(delta: float) -> State:
	if parent.position.distance_to(parent.navigation_agent.target_position) <= 20:
		parent.speed -= 10
	parent.direction = parent.position.direction_to(target)
	return null
	
func process_frame(delta: float) -> State:
	if parent.position.distance_to(parent.navigation_agent.target_position) <= 1:
		return idle_state
	return null
	
func exit() -> void:
	parent.speed = parent.default_speed
