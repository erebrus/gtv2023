extends Node2D

signal door_opened
signal door_closed
signal entered_door

@export var value:=false:
	set(v):
		value=v
		if v:
			open()
		else:
			close()
var player

func _ready():
	if value:
			open(true, true)
	else:
			close(true, true)


func is_open():
	return value
	
func open(force:=false, mute:=false):
	if is_open() and not force:
		return
	value=true
	Logger.debug("%s opening" % name)
	if not mute:
		$sfx_open.play()
	$sprites/open_sprite_left.visible = true
	$sprites/open_sprite_right.visible = true
	$sprites/closed_sprite.visible = false
	door_opened.emit()
	
func close(force:=false, mute:=false):
	if not is_open():
		return
	value=false
	if not mute:
		$sfx_close.play()
	$sprites/open_sprite_left.visible = false
	$sprites/open_sprite_right.visible = false
	$sprites/closed_sprite.visible = true
	door_closed.emit()
	
func _on_switched(val:bool, muted:=false)->void:
	if val:
		open(muted)
	else:
		close(muted)


func _on_body_entered(body):
	if value and body.has_method("set_object"):
		Logger.debug("%s player detected " % name)
		body.set_object(self)
		player = body


func _on_body_exited(body):
	Logger.debug("%s player lost " % name)
	if body.has_method("unset_object"):
		body.unset_object(self)
		
	

func interact():	
	if not player:
		return
	var tmp_player = player
	player.xsm.change_state("move")
	player.in_animation=true
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	var end_position = Vector2($end_position.global_position.x, player.global_position.y)	
	var duration = abs(end_position.x- player.global_position.x)/player.controller.max_speed
	$sprites/open_sprite_right.z_index+=10
	tween.tween_property(player, "global_position", end_position, duration)
	await tween.finished
	entered_door.emit()	
	tmp_player.in_animation=false

