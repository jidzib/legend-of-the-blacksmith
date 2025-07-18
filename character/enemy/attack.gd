extends State

@export var chase_state: State
@export var idle_state: State

var goal: Vector2
var slope: Vector2
var dash_strength = 2


func enter() -> void:
	parent.state = parent.States.ATTACK
	parent.attack_on_cooldown = true
	parent.attack_cooldown.start()
	parent.speed = 250
	parent.attack_hurtbox.visible = true
	slope = Vector2(Player.position.x - parent.position.x, Player.position.y - parent.position.y)
	goal = (parent.position + (slope * dash_strength))
	print("enemy attacking")

func process_physics(delta: float) -> State:
	parent.direction = (goal - parent.position).normalized()
	if goal.distance_to(parent.position) < 20:
		print(goal.distance_to(parent.position))
		parent.speed -= 10
	return null

func process_frame(delta: float) -> State:
	if parent.position.distance_to(goal) <= 1:
		print("returning idle_state")
		return idle_state	
	return null

func exit() -> void:
	parent.speed = 100
	parent.attack_hurtbox.visible = false

func _on_attack_hurtbox_body_entered(body: Node2D) -> void:
	if body.has_method("is_player"):
		body.take_damage(parent.attack_damage)
	parent.state_machine.change_state(idle_state)
	print("SHOULD BE IDLING")
