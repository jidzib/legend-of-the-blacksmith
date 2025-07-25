extends State

@export var idle_state: State
var knockback_speed: float = 400.0
var knockback_direction: Vector2

func enter() -> void:
	parent.state = parent.States.GOT_HIT
	parent.speed = knockback_speed
	parent.movement = knockback_direction
	parent.direction_locked = true
	parent.hitbox.set_deferred("disabled", true)
	print("player got hit")

func process_physics(delta: float) -> State:
	parent.movement = knockback_direction
	parent.velocity = lerp(parent.velocity, parent.movement * parent.speed, delta * parent.acceleration)
	parent.speed -= 20
	parent.move_and_slide()
	return null

func process_frame(delta: float) -> State:
	if parent.speed <= 0:
		return idle_state
	return null

func exit() -> void:
	parent.speed = parent.default_speed
	parent.direction_locked = false
	parent.movement.x = 0
	parent.hitbox.set_deferred("disabled", false)
