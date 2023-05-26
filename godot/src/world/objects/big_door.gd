@tool
extends Node2D

signal door_opened
signal door_closed

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
			open(true)
	else:
			close(true)


func is_open():
	return value
	
func open(force:=false):
	if is_open() and not force:
		return
	value=true
	Logger.debug ("%s opening" % name)
	$sfx_open.play()
	$sprites/open_sprite_left.visible = true
	$sprites/open_sprite_right.visible = true
	$sprites/closed_sprite.visible = false
	door_opened.emit()
	
func close(force:=false):
	if not is_open():
		return
	value=false
	$sfx_close.play()
	$sprites/open_sprite_left.visible = false
	$sprites/open_sprite_right.visible = false
	$sprites/closed_sprite.visible = true
	door_closed.emit()
	
func _on_switched(val:bool)->void:
	if val:
		open()
	else:
		close()


func _on_body_entered(body):
	if body.has_method("set_object"):
		Logger.debug("%s player detected " % name)
		body.set_object(self)
		player = body


func _on_body_exited(body):
	Logger.debug("%s player lost " % name)
	if body.has_method("unset_object"):
		body.unset_object(self)
		
	player = null
