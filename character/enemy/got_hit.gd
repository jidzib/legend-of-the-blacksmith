extends State

@export var idle_state: State
var knockback_speed: float = 400.0
var knockback_direction: Vector2
@onready var knockback_timer: Timer = $KnockbackTimer
var leave: bool = false

func enter() -> void:
	parent.state = parent.States.GOT_HIT
	parent.direction = knockback_direction
	parent.speed = knockback_speed
	leave = false
	knockback_timer.start()

func process_frame(delta: float) -> State:
	parent.speed -= 5
	if leave:
		return idle_state # return combat state (chase)
	return null

func exit() -> void:
	parent.speed = parent.default_speed

func _on_knockback_timer_timeout() -> void:
	leave = true
