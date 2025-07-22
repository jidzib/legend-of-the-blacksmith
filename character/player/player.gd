extends CharacterBody2D

# stats
var MAX_HP: float = 100
var hp: float = 100
var attack_damage: int = 20
const default_attack_damage: int = 20

# states
enum States {IDLE, WALK, FALL, SLASH, DASH}
var state: States = States.IDLE 
@onready var state_machine = $state_machine

# horizontal movement
var direction: Vector2 = Vector2(1, 0)
var speed: float = 300
var acceleration: float = 20
var movement: Vector2
var run_speed: float = 1.2

# vertical movement
var gravity: float = 15
var low_gravity_mod: float = 0.5
var jumping: bool
var jump_velocity: float = -80	
var jump_strength: float = -200
@onready var jump_timer: Timer = $JumpTimer
var max_fall_speed: float = 400
var on_floor: bool = false

# animation
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite: Sprite2D = $Sprite2D

# camera
@onready var camera: Camera2D = $Camera2D

# hitboxes
@onready var sword_hurtbox: CollisionShape2D = $SwordHurtbox/sword_hurtbox 

# audio
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D2

# timers
@onready var freeze_timer: Timer = $FreezeTimer

# particles
@onready var hit_effect: CPUParticles2D = $SwordHurtbox/HitEffect/CPUParticles2D

func is_player():
	pass
	
func _ready():
	self.position -= Vector2(200, -200)
	state_machine.init(self)
	animation_tree.active = true
	velocity = velocity.limit_length(1)
	hit_effect.top_level = true
	
func _physics_process(delta: float) -> void:
	if jumping: 
		velocity.y = jump_strength
		velocity.y += (gravity * low_gravity_mod) + jump_velocity
	else:
		velocity.y += gravity
	state_machine.process_physics(delta)
	
	# player direction
	if movement.x > 0:
		if direction != Vector2(1, 0):
			scale.x *= -1
		direction = Vector2(1, 0)
	elif movement.x < 0:
		if direction != Vector2(-1, 0):
			scale.x *= -1
		direction = Vector2(-1, 0)
		
	velocity = velocity.limit_length(max_fall_speed)
	
func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jumping = true	
		audio_player.randomize()
		audio_player.play()
		jump_timer.start()
			
	if Input.is_action_just_released("jump"):
		if jumping:
			velocity.y = 0
		jumping = false
		jump_timer.stop()
	
	if Input.is_action_just_pressed("dash"):
		state_machine.change_state(state_machine.get_node("dash"))
		
	state_machine.process_input(event)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)	
	if !is_on_floor():
		on_floor = false
		
func _on_coordinate_display_timeout() -> void:
	print("Current position: ", position)
	$CoordinateDisplay.start()

func _on_jump_timer_timeout() -> void:
	jumping = false
	velocity.y = 0

func take_damage(damage: int):
	hp -= damage
	sprite.material.set_shader_parameter("flash_color", Color(1.0, 0.0, 0.0, 1.0))
	freeze_timer.start()
	get_tree().paused = true
	if hp <= 0:
		die()
		
func die():
	respawn()
	
func respawn():
	position = Vector2(0, 0)
	hp = 100

func _on_freeze_timer_timeout() -> void:
	get_tree().paused = false
	sprite.material.set_shader_parameter("flash_color", Color(1.0, 1.0, 1.0, 1.0))
