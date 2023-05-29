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
	place_player()
	Globals.start_ambience()
	Globals.start_game_music()
	
		
		
func place_player() -> void:
	var entry: EntryPoint
	if entry_name.is_empty() and default_entry != null:
		entry = get_node(default_entry)
	else:
		entry = find_entry(self)
	
	assert(entry != null)
	Events.checkpoint_entered.emit(entry.name)
	$player.global_position = entry.global_position
	$player.velocity = entry.initial_velocity
	if entry.initial_velocity.x<0:
		$player/DirAnimationPlayer.play("left")
	$player.floor_type = floor_type
	var a = Globals.level_manager.current_dimension 
	var b = $player.dimension
	if Globals.level_manager.current_dimension != $player.dimension:
		$player.shift()
	$player.energy = Globals.level_manager.player_energy
	

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
		if floor_type==FloorType.GRASS:
			$TileMap.tile_set = MATERIAL_TS
			$CanvasModulate.color=Color("777777")
		else:
			$CanvasModulate.color=Color("333333")
		$Fog.visible = false
		$CanvasLayer/Tint.visible = false
		
	else:
		if floor_type==FloorType.GRASS:
			$TileMap.tile_set = SPECTRAL_TS
			$CanvasModulate.color=Color("aaaaaa")
		else:
			$CanvasModulate.color=Color("000000")
		$Fog.visible = true
		$CanvasLayer/Tint.visible = true
		
	

