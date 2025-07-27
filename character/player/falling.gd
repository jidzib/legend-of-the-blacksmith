extends State

@export var idle_state: State
@export var walk_state: State
@export var slash_state: State

var horizontal_jump_strength: float = 400.0
var default_horizontal_jump_strength: float = 400.0
var jumping_off_wall: bool = false
var jump_direction: int

func enter() -> void:
	parent.state = parent.States.FALL
	print("is falling")
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("slash"):
		return slash_state
		
	if Input.is_action_just_pressed("jump") and parent.front_raycast.is_colliding():
		jump_direction = parent.direction.x * -1
		jumping_off_wall = true
		parent.move_and_slide()
		parent.jumping = true
		parent.audio_player.randomize()
		parent.audio_player.play()
		parent.jump_timer.start()	
	return null
	
func process_physics(delta: float) -> State:
	if parent.is_on_floor():
		if parent.movement.x == 0:
			return idle_state
		else:
			return walk_state
			
	# player movement
	if !jumping_off_wall:
		parent.movement.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		parent.velocity.x = lerp(parent.velocity.x, parent.movement.x * parent.speed * 0.8, delta * parent.acceleration)
		parent.move_and_slide()
	elif jumping_off_wall:
		parent.velocity.x = lerp(parent.velocity.x, jump_direction * horizontal_jump_strength * 0.8, delta * parent.acceleration)
		parent.move_and_slide()
		horizontal_jump_strength -= 40
		if horizontal_jump_strength <= 0:
			horizontal_jump_strength = default_horizontal_jump_strength
			jumping_off_wall = false
	return null
		
func process_frame(delta: float) -> State:
	if !parent.on_floor and parent.is_on_floor():
		parent.on_floor = true
	return null
