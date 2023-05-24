extends Node2D

const MATERIAL_TS = preload("res://src/world/cemetery_tileset_material.tres")
const SPECTRAL_TS = preload("res://src/world/cemetery_tileset_spectral.tres")
var dimension = Events.Dimension.SPECTRAL


func _ready():
	Events.dimension_changed.emit(dimension)
	Events.dimension_changed.connect(_on_dimension_changed)
	$player/Camera2D.moved.connect(_on_camera_moved)

func _on_dimension_changed(_dimension):
	if dimension == _dimension:
		return
	dimension = _dimension
	if dimension == Events.Dimension.MATERIAL:
		$TileMap.tile_set = MATERIAL_TS
		$CanvasLayer/Fog.visible = false
		$CanvasLayer/Tint.visible = false
	else:
		$TileMap.tile_set = SPECTRAL_TS
		$CanvasLayer/Fog.visible = true
		$CanvasLayer/Tint.visible = true
	

func _on_camera_moved():
	$CanvasLayer/Fog.material.set_shader_parameter("offset", $player/Camera2D.global_position)
