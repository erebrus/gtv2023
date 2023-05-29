extends StaticBody2D


@export var initial_status:bool = false

func _ready():
	$sprite.modulate=Color(Color.WHITE) if initial_status else Color(1,1,1,0)
	$CollisionShape2D.disabled = !initial_status

func appear(mute:bool = false):
	$AnimationPlayer.play("fade_in")
	if not mute:
		$sfx_spawn.play()

func disappear(mute:bool = false):	
	$AnimationPlayer.play("fade_out")
	if not mute:
		$sfx_despawn.play()

func _on_switched(val:bool, muted:=false)->void:
	if val: 
		appear(muted)
	else:
		disappear(muted)


