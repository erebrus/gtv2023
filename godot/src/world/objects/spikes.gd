extends Area2D

func _ready():
	Events.dimension_changed.connect(_on_dimension_changed)
	


func _on_dimension_changed(dimension):
	if dimension == Events.Dimension.MATERIAL:
		if not get_overlapping_bodies().is_empty():
			for body in get_overlapping_bodies():
				if body.has_method("on_environment_damage"):
					await get_tree().process_frame
					body.on_environment_damage()

func _on_body_entered(body):
	if body.has_method("on_environment_damage"):
		body.on_environment_damage()
