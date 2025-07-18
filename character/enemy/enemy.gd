extends CharacterBody2D

# movement
var speed: float = 100

# stats
var max_hp: float = 100
var hp: float = 100
var attack_damage: int = 20

# direction
var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, -1), Vector2(0, 1)] # right, left, up, down
@onready var raycast: RayCast2D = $RayCast2D
var direction_index: int = 3
var direction: Vector2

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

func is_enemy():
	pass
	
func _ready():
	state_machine.init(self)
	update_raycast()
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	velocity = direction * speed
	raycast.target_position = direction * 20
	move_and_slide()
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	if raycast.is_colliding() and !raycast.get_collider().has_method("is_player"):
		state_machine.change_state(state_machine.starting_state)
			
func update_raycast():
	raycast.target_position = directions[direction_index] * 25

func update_direction():
	update_raycast()

func damage(damage_dealt: int, damage_source: CollisionShape2D):
	hp -= damage_dealt
	sprite.material.set_shader_parameter("flash_color", Color(1.0, 0.0, 0.0, 1.0))
	freeze_timer.start()
	get_tree().paused = true
	if hp <= 0:
		die()
	direction = Vector2(position.x - damage_source.position.x, position.y - damage_source.position.y)
		
func die():
	get_tree().paused = false
	queue_free()


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
