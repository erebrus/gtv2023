extends StaticBody2D

signal door_opened
signal door_closed

@onready var sprite := $sprite

func is_open()->bool:
	return collision_mask & Globals.Layer.WORLD == 0
	
func open():
	if is_open():
		return
	sprite.play("open")
	await sprite.animation_finished
	door_opened.emit()
	
func close():
	if not is_open():
		return
	sprite.play("close")	
	await sprite.animation_finished
	door_closed.emit()
	
func on_switched(val:bool)->void:
	if val:
		open()
	else:
		close()
