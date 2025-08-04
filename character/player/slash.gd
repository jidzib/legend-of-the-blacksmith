extends State

@export var idle_state: State
@export var fall_state: State
@export var walk_state: State

var return_state: State = null
@onready var timer = $AnimationTimer

func enter() -> void:
	parent.state = parent.States.SLASH
	timer.start()
	return_state = null
	
func process_physics(delta: float) -> State:
	parent.movement.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	parent.velocity.x = lerp(parent.velocity.x, parent.movement.x * parent.speed, delta * parent.acceleration)
	parent.move_and_slide()

	return null

func process_frame(delta: float) -> State:
	return return_state

func timeout() -> void: # called at end of animation in animationplayer
	if parent.movement.y != 0:
		return_state = fall_state
	elif parent.movement.x == 0:
		return_state = idle_state
	if Input.is_action_pressed("right") or Input.is_action_pressed("left"):
		return_state = walk_state
	
func exit() -> void:
	parent.animation_tree.get("parameters/playback").travel("walk")

func _on_sword_hurtbox_body_entered(body: Node2D) -> void:
	if body.has_method("is_enemy"):
		parent.hit_effect.global_position = body.position
		parent.hit_effect.emitting = true
		
