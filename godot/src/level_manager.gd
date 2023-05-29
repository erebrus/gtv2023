class_name LevelManager extends Node

const MAX_PLAYER_ENERGY = 100
const START_PLAYER_ENERGY = MAX_PLAYER_ENERGY / 2

var current_level_path: String
var last_checkpoint: String
var current_dimension:Events.Dimension = Events.Dimension.SPECTRAL
var player_energy:=START_PLAYER_ENERGY

const path="usr://game_conf.tres"

func _ready():
	load_data()
	Events.change_level_requested.connect(change_level)
	Events.checkpoint_entered.connect(save_checkpoint)
	current_level_path = get_tree().current_scene.scene_file_path
	

func reset_level() -> void:
	change_level(Globals.MAIN_SCREEN, "", Events.Dimension.SPECTRAL, START_PLAYER_ENERGY)
	

func has_checkpoint() -> bool:
	return not last_checkpoint.is_empty()
	

func save_checkpoint(checkpoint_name: String) -> void:
	last_checkpoint = checkpoint_name
	Logger.info("Saved checkpoint: %s" % checkpoint_name)
	

func restore_checkpoint() -> void:
	Logger.info("Restoring checkpoint: %s" % last_checkpoint)
	change_level(current_level_path, last_checkpoint, current_dimension, START_PLAYER_ENERGY)
	

func change_level(next_level: String, entry_name: String, dimension:Events.Dimension, _player_energy:float) -> void:
	current_dimension = dimension
	player_energy = _player_energy
	current_level_path = next_level
	var set_entry_point = func(scene):
		scene.entry_name = entry_name
	
	SceneManager.change_scene(next_level, {"on_tree_enter": set_entry_point})
	

func load_data():
	if ResourceLoader.exists(path):		
		Logger.info("Config loaded.")
	else:
		Logger.info("No configuration found.")

func save_data():
	return
#	var conf := GameConfiguration.new()
#	conf.current_deck = current_deck
#	conf.last_level = current_level
#	conf.highest_level = highest_level
#
#	var error = ResourceSaver.save(conf, path)
#	if error != OK:
#		Logger.error("Failure!")
#	else:
#		Logger.info("Config saved.")

func _exit_tree():
	save_data()
