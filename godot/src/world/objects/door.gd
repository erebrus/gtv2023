extends StaticBody2D

signal door_opened
signal door_closed

@onready var sprite := $sprite

func is_open()->bool:
	return $CollisionShape2D.disabled#collision_mask & Globals.Layer.WORLD == 0
	
func open():
	if is_open():
		return
	Logger.debug ("%s opening" % name)
	sprite.play("open")
#	await sprite.animation_finished
	$CollisionShape2D.disabled=true
	collision_layer=0
	door_opened.emit()
	
func close():
	if not is_open():
		return
	sprite.play("close")	
	Logger.debug ("%s closing" % name)
#	await sprite.animation_finished
	$CollisionShape2D.disabled=false
	collision_layer=1
	door_closed.emit()
	
func _on_switched(val:bool)->void:
	if val: 
		open()
	else:
		close()

