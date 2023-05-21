extends Node2D

const MATERIAL_TS = preload("res://src/world/cemetery_tileset_material.tres")
const SPECTRAL_TS = preload("res://src/world/cemetery_tileset_spectral.tres")
var dimension = Events.Dimension.SPECTRAL
@onready var spectral_canvas = $spectral_canvas

func _ready():
	Events.dimension_changed.emit(dimension)
	Events.dimension_changed.connect(_on_dimension_changed)
	

func _on_dimension_changed(_dimension):
	if dimension == _dimension:
		return
	dimension = _dimension
	spectral_canvas.visible = dimension == Events.Dimension.SPECTRAL
	if dimension == Events.Dimension.MATERIAL:
		$TileMap.tile_set = SPECTRAL_TS
	else:
		$TileMap.tile_set = MATERIAL_TS
#	if dimension == Events.Dimension.MATERIAL:
#		$AnimationPlayer.play("to_material")
#	else:
#		$AnimationPlayer.play("to_spectral")
#
