extends State

@export var idle_state: State
@export var walk_state: State
@export var slash_state: State


func enter() -> void:
	parent.state = parent.States.FALL
	print("is falling")
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("slash"):
		return slash_state
	return null
	
func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	if parent.is_on_floor():
		if parent.movement.x == 0:
			return idle_state
		else:
			return walk_state
			
	# player movement
	parent.movement.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	parent.velocity.x = lerp(parent.velocity.x, parent.movement.x * parent.speed * 0.8, delta * parent.acceleration)
	parent.move_and_slide()
	
	return null
