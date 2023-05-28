extends Area2D


@export_file("*.tscn") var next_level: String
@export var entry_point: String
@export var extents:Vector2=Vector2.ZERO

func _ready():
	if extents != Vector2.ZERO:
		$CollisionShape2D.shape.extents=extents
	
func _on_body_entered(_body):
	Events.change_level_requested.emit(next_level, entry_point)
