extends State

func _on_update(_delta: float) -> void:
	if not is_active("attack") and Input.is_action_just_pressed("attack"):
		change_state("attack")
