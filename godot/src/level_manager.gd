class_name LevelManager extends Node

const START_GAME = 2

var levels:Array[PackedScene] = [
	preload("res://src/world/example.tscn"),
	
	
]
var current_level:int = 0

const path="usr://game_conf.tres"

func _ready():
	load_data()


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
