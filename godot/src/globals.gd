extends Node

enum GameLogLevel {INFO, WARNING, ALERT}

enum Layer {WORLD = 1, PLAYER = 16, ENEMY = 32}

var master_volume:float = 100
var music_volume:float = 100
var sfx_volume:float = 100

const GameDataPath = "user://conf.cfg"
var config:ConfigFile

var debug_build := false



const MENU_SCREEN = "res://src/menu/menu.tscn"
const MAIN_SCREEN = "res://src/main.tscn"
const GAMEOVER_SCREEN = "res://src/world/example.tscn"
const WIN_SCREEN = "res://src/win/win_screen.tscn"
const CHOOSE_PIECE = "res://src/choose_piece/choose_piece.tscn"

const TRANSITION_COLOR = Color("#009aff")



var default_transition = {
	"pattern":"horizontal", 
	"wait_time":0,
	"color": TRANSITION_COLOR
}

var game_music_on := false
@onready var level_manager:LevelManager = $LevelManager
@onready var music:=$music

func _ready():
	_init_logger()
	Logger.info("Init complete.")


func start_game_music()->void:
	if not music.playing:
		music.volume_db=-80
		music.play()
		var tween:=create_tween().set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(music, "volume_db",-15.0, 1)
		game_music_on = true


func stop_game_music()->void:
	music.stop()
	game_music_on = false
		
func _init_logger():

	Logger.set_logger_level(Logger.LOG_LEVEL_DEBUG)
	Logger.set_logger_format(Logger.LOG_FORMAT_MORE)
	var file_appender:Appender = Logger.add_appender(FileAppender.new("res://debug.log"))
	file_appender.logger_format=Logger.LOG_FORMAT_FULL
	file_appender.logger_level = Logger.LOG_LEVEL_TRACE


func gameover():
	await get_tree().create_timer(0.5).timeout
	level_manager.restore_checkpoint()
	

func win():
	SceneManager.change_scene(WIN_SCREEN, default_transition)
	

func menu():
	SceneManager.change_scene(MENU_SCREEN, default_transition)
	

func can_continue() -> bool:
	return level_manager.current_level > 0
	

func tutorial():
	level_manager.tutorial_level()
	_main_screen()
	

func start():
	level_manager.reset_level()
	_main_screen()
	

func continue_game():
	_main_screen()
	

func next_level():
	if level_manager.is_last_level():
		menu()
	else:
		level_manager.next_level()
		
		if level_manager.is_tutorial():
			_main_screen()
		else:
			choose_piece()
	

func _main_screen():
	SceneManager.change_scene(MAIN_SCREEN, default_transition)
	start_game_music()
	

func choose_piece():
	SceneManager.change_scene(CHOOSE_PIECE, {
			"pattern_enter":"curtains", 
			"wait_time":0, 
			"color": TRANSITION_COLOR,
		})
	

func _on_music_finished():
	if game_music_on:
		start_game_music()
