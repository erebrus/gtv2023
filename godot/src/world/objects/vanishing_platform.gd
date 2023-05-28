extends StaticBody2D


@export var initial_status:bool = false

func _ready():
	$sprite.modulate=Color(Color.WHITE) if initial_status else Color(1,1,1,0)
	$CollisionShape2D.disabled = !initial_status

func appear():
	$AnimationPlayer.play("fade_in")

func disappear():
	$AnimationPlayer.play("fade_out")

func _on_switched(val:bool)->void:
	if val: 
		appear()
	else:
		disappear()
