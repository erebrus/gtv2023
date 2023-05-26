extends Area2D


@export_file("*.tscn") var next_level: String
@export var entry_point: String


func _on_body_entered(_body):
	Events.change_level_requested.emit(next_level, entry_point)
