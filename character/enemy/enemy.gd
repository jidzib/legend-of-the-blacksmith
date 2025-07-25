extends CharacterBody2D

# stats
var max_hp: float = 100
var hp: float = 100
var attack_damage: float = 20
var speed: float = 100
var default_speed: float = 100

# direction
@onready var raycast: RayCast2D = $RayCast2D
var direction: Vector2
var raycast_length: float = 50

# states and state machine
enum States {IDLE, CHASE, ATTACK, FLEE, GOT_HIT}
var state: States = States.IDLE
@onready var state_machine = $state_machine
var player_in_range: bool = false
var in_attack_range: bool = false

# attacks 
@onready var attack_cooldown = $attack_cooldown
var attack_on_cooldown: bool = false

# hitboxes
@onready var wander_range: CollisionShape2D = $WanderRange/CollisionShape2D
@onready var attack_range: CollisionShape2D = $AttackRange/CollisionShape2D
@onready var attack_hurtbox: CollisionShape2D = $AttackHurtbox/CollisionShape2D
@onready var chase_area: Area2D = $ChaseRange

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
var knockback: Vector2 = Vector2(1, 1)

func is_enemy():
	pass
	
func _ready():
	state_machine.init(self)
	attack_hurtbox.set_deferred("disabled", true)
	check_intersecting_areas()
	
	update_raycast()
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	if !navigation_agent.is_target_reachable():
		if raycast.is_colliding() and !raycast.get_collider().has_method("is_player"):	
			state_machine.change_state(state_machine.starting_state)
	velocity = direction * speed
	navigation_agent.velocity = direction * speed
	
	update_raycast()
	move_and_slide()
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	#if raycast.is_colliding() and !raycast.get_collider().has_method("is_player"):
		#state_machine.change_state(state_machine.starting_state)
			
func update_raycast():
	raycast.target_position = direction * raycast_length

func deal_damage(receiver: CharacterBody2D) -> void:
	receiver.take_damage(self, attack_damage)
	flee_location = position + ((position.direction_to(receiver.position) * -1) * 30)
	
func take_damage(source: CharacterBody2D, damage: float):
	hp -= damage
	sprite.material.set_shader_parameter("flash_color", Color(1.0, 0.0, 0.0, 1.0))
	print("Enemy HP remaining: ", hp)
	freeze_timer.start()
	get_tree().paused = true
	if hp <= 0:
		die()
	state_machine.get_node("got_hit").knockback_direction = source.position.direction_to(position)
	state_machine.change_state(state_machine.get_node("got_hit"))
		
func die():
	get_tree().paused = false
	queue_free()

func random_point(circle: CircleShape2D) -> void:
	for i in range(1000):
		radius = rng.randf_range(0, circle.radius)
		theta = rng.randf_range(0, 2*PI)
		target = Vector2(radius * cos(theta), radius * sin(theta)) + position
		navigation_agent.target_position = target
		if navigation_agent.is_target_reachable():
			return

func check_intersecting_areas() -> void:
	print("Overlapping areas: ", chase_area.get_overlapping_areas())
	for body in chase_area.get_overlapping_areas():
		if body.has_method("is_player"):
			player_in_range = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("is_player"):
		player_in_range = true
		print("Player entered range")

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

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("is_player"):
		area.get_parent().deal_damage(self)
