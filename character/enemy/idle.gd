extends State

@export var chase_state: State

var target: Vector2
var rng = RandomNumberGenerator.new()

func enter() -> void:
	parent.state = parent.States.IDLE
	parent.wander_range.position = Vector2(0, 0)
	parent.wander_range.top_level = true
	# generating random point to move to in the wander circle
	target = random_point()
	parent.navigation_agent.target_position = random_point()
	print("enemy idling")
	
func process_physics(delta: float) -> State:
	if parent.position.distance_to(parent.navigation_agent.target_position) <= 1:
		target = random_point()
		parent.navigation_agent.target_position = random_point()
	parent.direction = parent.position.direction_to(target)
	return null
	
func process_frame(delta: float) -> State:
	if parent.player_in_range and !parent.attack_on_cooldown:
		return chase_state
	return null

func exit() -> void:
	parent.wander_range.top_level = false

func random_point() -> Vector2:
	var radius = rng.randf_range(0, parent.wander_range.shape.radius)
	var theta = rng.randf_range(0, 2*PI)
	return Vector2(radius * cos(theta), radius * sin(theta))
