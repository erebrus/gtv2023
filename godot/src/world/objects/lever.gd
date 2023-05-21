extends Area2D

signal switched(value:bool)

@export var value := false
var player

func _ready():
	if value:
		switch()
	Events.dimension_changed.connect(_on_dimension_changed)		


func switch():
	value = not value
	switched.emit(value)
		
func _on_dimension_changed(dimension):	
	if dimension == Events.Dimension.SPECTRAL and player:
		player.unset_object(self)
	monitoring = dimension == Events.Dimension.MATERIAL
	
			

func _on_body_entered(body):
	if body.has_method("set_object"):
		body.set_object(self)
		player = body


func _on_body_exited(body):
	if body.has_method("unset_object"):
		body.unset_object(self)
		player = null
