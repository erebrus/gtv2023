extends Node2D

var player
var dest_angle:float
func _physics_process(delta):
	if player:
		dest_angle = global_position.angle_to(player.global_position)
	else:
		dest_angle = -PI/4
		
func _on_body_entered(body):
	player = body


func _on_body_exited(body):
	player = null
