class_name LevelManager extends Node

const START_GAME = 2

var levels:Array[PackedScene] = [
	preload("res://src/world/testmap.tscn"),
	
	
]
var current_level:int = 0
var current_level_path: String
var last_checkpoint: String

const path="usr://game_conf.tres"

func _ready():
	load_data()
	Events.change_level_requested.connect(change_level)
	Events.checkpoint_entered.connect(save_checkpoint)
	current_level_path = get_tree().current_scene.scene_file_path

func is_last_level() -> bool:
	return current_level >= levels.size() - 1
	

func is_tutorial() -> bool:
	return current_level < START_GAME
	

func tutorial_level():
	current_level = 0
	

func next_level():
	current_level += 1
	if current_level >= levels.size():
		current_level = 0
	

func reset_level():
	current_level = START_GAME
	

func get_current_level()->PackedScene:
	return levels[current_level]
	

func get_next_level()->PackedScene:
	current_level += 1
	if current_level >= levels.size():
		current_level = 0
	return get_current_level()
	

func save_checkpoint(checkpoint_name: String) -> void:
	last_checkpoint = checkpoint_name
	Logger.info("Saved checkpoint: %s" %checkpoint_name)
	

func restore_checkpoint() -> void:
	change_level(current_level_path, last_checkpoint)
	

func change_level(next_level: String, entry_name: String) -> void:
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
