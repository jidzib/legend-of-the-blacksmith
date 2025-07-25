extends Node


func _ready():
	pass

func _on_tree_entered() -> void:
	GlobalSignal.spawn_entity.connect(spawn_entity)
	
func _on_tree_exited() -> void:
	GlobalSignal.spawn_entity.disconnect(spawn_entity)

func spawn_entity(str: String, entity: PackedScene):
	var new_entity = entity.instantiate()
	add_child(new_entity)
	new_entity.position = Player.position + Vector2(200, 0)
