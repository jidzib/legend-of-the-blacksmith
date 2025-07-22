extends CharacterBody2D


# stats
var max_hp: float = 100
var hp: float = 100
var attack_damage: int = 20
var speed: float = 100
var default_speed: float = 100

# direction
@onready var raycast: RayCast2D = $RayCast2D
var direction: Vector2
var raycast_length: float = 50

# states and state machine
enum States {IDLE, CHASE, ATTACK, FLEE}
var state: States = States.IDLE
@onready var state_machine = $state_machine
var player_in_range: bool = false
var in_attack_range: bool = false

# attacks 
@onready var attack_cooldown = $attack_cooldown
var attack_on_cooldown: bool = false

# hitboxes
@onready var wander_range = $WanderRange/CollisionShape2D
@onready var attack_hurtbox: Area2D = $AttackHurtbox

# animation
@onready var sprite: Sprite2D = $Sprite2D

# timers
@onready var freeze_timer: Timer = $FreezeTimer

@onready var pointer: Marker2D = $player_position

# pathfinding
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
var rng = RandomNumberGenerator.new()
var goal: Vector2
var target: Vector2
var radius: float
var theta: float

var flee_location: Vector2

func is_enemy():
	pass
	
func _ready():
	state_machine.init(self)
	update_raycast()
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	if !navigation_agent.is_target_reachable():
		if raycast.is_colliding() and !raycast.get_collider().has_method("is_player"):	
			state_machine.change_state(state_machine.starting_state)
	direction = position.direction_to(goal)
	velocity = direction * speed
	navigation_agent.velocity = direction * speed

	#print("Current state: ", state, " (0: IDLE, 1: CHASE, 2: ATTACK, 3: FLEE)")
	#print("Current position: ", position)
	#print("Global position: ", global_position)
	#print("Direction: ", direction)
	#print("Next position: ", navigation_agent.get_next_path_position())
	#print("Target position: ", navigation_agent.target_position)
	#print("Agent velocity: ", navigation_agent.velocity)
	#print("Path index: ", navigation_agent.get_current_navigation_path_index())
	#print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
	
	update_raycast()
	move_and_slide()
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	#if raycast.is_colliding() and !raycast.get_collider().has_method("is_player"):
		#state_machine.change_state(state_machine.starting_state)
			
func update_raycast():
	raycast.target_position = direction * raycast_length

func damage(damage_dealt: int, damage_source: CollisionShape2D):
	hp -= damage_dealt
	sprite.material.set_shader_parameter("flash_color", Color(1.0, 0.0, 0.0, 1.0))
	print("Enemy HP remaining: ", hp)
	freeze_timer.start()
	get_tree().paused = true
	if hp <= 0:
		die()
	flee_location = position + ((position.direction_to(damage_source.position) * -1) * 30)
	state_machine.change_state(state_machine.get_node("flee"))
		
func die():
	get_tree().paused = false
	queue_free()

func random_point() -> void:
	
	radius = rng.randf_range(0, wander_range.shape.radius)
	theta = rng.randf_range(0, 2*PI)
	target = Vector2(radius * cos(theta), radius * sin(theta))
	navigation_agent.target_position = target
	
	if !navigation_agent.is_target_reachable():
		random_point()
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("is_player"):
		player_in_range = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("is_player"):
		player_in_range = false

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.has_method("is_player"):
		in_attack_range = true

func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.has_method("is_player"):
		in_attack_range = false

func _on_attack_cooldown_timeout() -> void:
	attack_on_cooldown = false

func _on_freeze_timer_timeout() -> void:
	sprite.material.set_shader_parameter("flash_color", Color(1.0, 1.0, 1.0, 1.0))
	get_tree().paused = false
