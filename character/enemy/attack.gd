extends State

@export var chase_state: State
@export var idle_state: State

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
	parent.attack_hurtbox.visible = true
	slope = Vector2(Player.position.x - parent.position.x, Player.position.y - parent.position.y)
	parent.goal = (parent.position + (slope * dash_strength))
	print("enemy attacking")

func process_physics(delta: float) -> State:
	if parent.position.distance_to(parent.goal) <= slow_down_distance:
		parent.speed -= 10
	return null

func process_frame(delta: float) -> State:
	if parent.raycast.is_colliding() and !parent.raycast.get_collider().has_method("is_player"):
		return idle_state
	if parent.position.distance_to(parent.goal) <= stop_distance:
		print("returning idle_state")
		return idle_state	
	return null

func exit() -> void:
	parent.speed = parent.default_speed
	parent.attack_hurtbox.visible = false

func _on_attack_hurtbox_body_entered(body: Node2D) -> void:
	if body.has_method("is_player"):
		body.take_damage(parent.attack_damage)
		parent.state_machine.change_state(parent.state_machine.get_node("flee"))
