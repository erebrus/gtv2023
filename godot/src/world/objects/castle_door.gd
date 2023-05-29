extends "res://src/world/objects/big_door.gd"

@export_file("*.tscn") var next_level: String
# Called when the node enters the scene tree for the first time.
func _ready():
	entered_door.connect(_on_entered_door)


func _on_entered_door():
	Events.change_level_requested.emit(next_level, "",player.dimension, player.energy)

