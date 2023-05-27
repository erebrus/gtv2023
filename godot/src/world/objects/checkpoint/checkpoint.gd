class_name Checkpoint extends EntryPoint


func _on_body_entered(_body):
	Events.checkpoint_entered.emit(name)
