extends ProgressBar


func _on_tree_entered() -> void:
	GlobalSignal.player_hp.connect(update_healthbar)

func _on_tree_exited() -> void:
	GlobalSignal.player_hp.disconnect(update_healthbar)

func update_healthbar(current_health: float) -> void:
	value = current_health
	print(value)
	if value >= max_value / 2:
		print("Green")
		modulate = Color(0.0, 1.0, 0.0, 1.0)
	elif value >= max_value / 4:
		modulate = Color(1.0, 1.0, 0.0, 1.0)
		print("Yellow")
	else:
		modulate = Color(1.0, 0.0, 0.0, 1.0)
		print("Red")
