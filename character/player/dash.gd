extends State

@export var walk_state: State

var dash_speed: float = 800.0
var dash_distance: float = 100.0
var distance_traveled: float
var prev_frame_position: Vector2

func enter() -> void:
	parent.state = parent.States.DASH
	distance_traveled = 0.0
	prev_frame_position = parent.position
	parent.attack_damage *= 2
	parent.dash_timer.start()
	parent.dash_on_cooldown = true
	print("is dashing")
	
func process_physics(delta: float) -> State:
	parent.velocity.x = dash_speed * parent.direction.x
	parent.move_and_slide()
	return null
	
func process_frame(delta: float) -> State:
	distance_traveled += prev_frame_position.distance_to(parent.position)
	prev_frame_position = parent.position
	
	if distance_traveled >= dash_distance:
		return walk_state
	return null
	
func exit() -> void:
	parent.attack_damage = parent.default_attack_damage
