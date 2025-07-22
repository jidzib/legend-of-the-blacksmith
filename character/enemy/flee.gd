extends State

@export var idle_state: State
var slow_down_distance: float = 64.0
var stop_distance: float = 16.0
var flee_distance: float = 160.0

func enter() -> void:
	parent.state = parent.States.FLEE
	parent.speed = 250
	parent.navigation_agent.target_position = parent.flee_location
	
	print("enemy fleeing")
	
func process_physics(delta: float) -> State:
	parent.goal = parent.navigation_agent.get_next_path_position()
	if parent.position.distance_to(parent.goal) <= slow_down_distance:
		parent.speed -= 10
	return null
	
func process_frame(delta: float) -> State:
	if parent.position.distance_to(parent.goal) <= stop_distance:
		return idle_state
	return null
	
func exit() -> void:
	parent.speed = parent.default_speed
 
