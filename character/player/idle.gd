extends State

@export var walk_state: State
@export var fall_state: State
@export var slash_state: State

func enter() -> void:
	parent.state = parent.States.IDLE
	parent.velocity.x = 0
	print("is idling")

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("slash"):
		return slash_state
	elif (Input.is_action_pressed("right") or Input.is_action_pressed("left")):
		return walk_state
	return null

func process_physics(delta: float) -> State:
	parent.move_and_slide()
	parent.animation_tree.set("parameters/walk/blend_position", parent.movement.x)
	return null

func process_frame(delta: float) -> State:
	if not parent.is_on_floor():
		return fall_state
	return null
