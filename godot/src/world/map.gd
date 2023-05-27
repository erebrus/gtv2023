extends Node2D
class_name Map

enum FloorType{GRASS, ROCK}

const MATERIAL_TS = preload("res://src/world/cemetery_tileset_material.tres")
const SPECTRAL_TS = preload("res://src/world/cemetery_tileset_spectral.tres")
var dimension = Events.Dimension.SPECTRAL

@export var floor_type:FloorType = FloorType.GRASS
@export var level:PackedScene
@export var default_entry: NodePath
var entry_name := ""

func _ready():
	Events.dimension_changed.emit(dimension)
	Events.dimension_changed.connect(_on_dimension_changed)
	$player/Camera2D.moved.connect(_on_camera_moved)
	place_player()
	

func place_player() -> void:
	var entry: EntryPoint
	if entry_name.is_empty() and default_entry != null:
		entry = get_node(default_entry)
	else:
		entry = find_entry(self)
	
	assert(entry != null)
	Events.checkpoint_entered.emit(entry.name)
	$player.position = entry.position
	$player.floor_type = floor_type
	

func find_entry(node: Node) -> EntryPoint:
	for child in node.get_children():
		if child is EntryPoint and (entry_name.is_empty() or child.name == entry_name):
			return child
		else:
			var result = find_entry(child)
			if result != null:
				return result
	return null
			
			
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
