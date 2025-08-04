extends Area2D

var checkpoint: Vector2

func _ready() -> void:
	checkpoint = position

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("is_player"):
		body.spawnpoint = checkpoint
