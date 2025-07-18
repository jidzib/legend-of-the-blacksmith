extends State

@export var idle_state: State
@export var fall_state: State
@export var slash_state: State

func enter() -> void:
	print("is walking")
	parent.state = parent.States.WALK

func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("slash"):
		return slash_state
	return null
	
func process_frame(delta: float) -> State:
	if not parent.is_on_floor():
		return fall_state
	return null

func process_physics(delta: float) -> State:
	
	# player movement
	parent.movement.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	parent.velocity.x = lerp(parent.velocity.x, parent.movement.x * parent.speed, delta * parent.acceleration)

	parent.move_and_slide()
		
	if parent.movement.x == 0:
		return idle_state
	parent.animation_tree.set("parameters/walk/blend_position", parent.movement.x)
	return null
