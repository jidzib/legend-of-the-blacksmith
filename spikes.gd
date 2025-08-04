extends StaticBody2D

var damage: float = 25

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.has_method("is_player"):
		print("hit player")
		body.hp -= damage
		GlobalSignal.player_hp.emit(body.hp)
		if body.hp <= 0:
			body.die()
		else:
			body.position = body.spawnpoint
