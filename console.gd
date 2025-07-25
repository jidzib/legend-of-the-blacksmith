extends LineEdit

var enemy = load("res://character/enemy/enemy.tscn")


enum Commands {
	SPAWN_ENEMY
}

var command_map = {
	"spawn_enemy": Commands.SPAWN_ENEMY
}

func _ready() -> void:
	visible = false
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_console"):
		visible = true
		grab_focus()
		get_tree().paused = true

func _on_text_submitted(new_text: String) -> void:
	if new_text in command_map:
		spawn_enemy(new_text)

func spawn_enemy(str: String) -> void:
	GlobalSignal.spawn_entity.emit(str, enemy)

func _on_editing_toggled(toggled_on: bool) -> void:
	if !toggled_on:
		clear()
		visible = false
		get_tree().paused = false
