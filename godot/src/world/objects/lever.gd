extends Area2D

signal switched(value:bool, muted:bool)

@export var value := false

var player

func _ready():
	if value:
		$sprite.play("on")
	Events.dimension_changed.connect(_on_dimension_changed)		


func interact(mute:=false):
	
	value = not value
	Logger.debug("%s switched . new value=%s" % [name, value])
	switched.emit(value, mute)
	if value:
		$sprite.play("on")
		if not mute:
			$sfx_on.play()
	else:
		$sprite.play("off")
		if not mute:
			$sfx_off.play()
		
func _on_dimension_changed(dimension):	
	if dimension == Events.Dimension.SPECTRAL and player:
		player.unset_object(self)
	monitoring = dimension == Events.Dimension.MATERIAL
	
			

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
