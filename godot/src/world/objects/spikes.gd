extends Area2D


func _on_body_entered(body):
	if body.has_method("on_environment_damage"):
		body.on_environment_damage()
