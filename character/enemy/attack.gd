extends State

@export var chase_state: State
@export var idle_state: State
@export var flee_state: State

#var goal: Vector2
var slope: Vector2
var dash_strength = 2
var slow_down_distance: float = 64
var stop_distance: float = 16

func enter() -> void:
	parent.state = parent.States.ATTACK
	parent.attack_on_cooldown = true
	parent.attack_cooldown.start()
	parent.speed = 250
	parent.attack_hurtbox.set_deferred("disabled", false)
	slope = Vector2(Player.position.x - parent.position.x, Player.position.y - parent.position.y)
	parent.goal = (parent.position + (slope * dash_strength))
	parent.direction = parent.position.direction_to(parent.goal)
	parent.flee_location = parent.position
	print("enemy attacking")

func process_physics(delta: float) -> State:
	if parent.position.distance_to(parent.goal) <= slow_down_distance:
		parent.speed -= 10
	return null

func process_frame(delta: float) -> State:
	if parent.raycast.is_colliding() and !parent.raycast.get_collider().has_method("is_player"):
		return flee_state
	if parent.position.distance_to(parent.goal) <= stop_distance:
		return flee_state	
	return null

func exit() -> void:
	parent.speed = parent.default_speed
	parent.attack_hurtbox.set_deferred("disabled", true)

func _on_attack_hurtbox_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("is_player"):
		print("HIT PLAYER") 
		parent.state_machine.change_state(parent.state_machine.get_node("flee"))
