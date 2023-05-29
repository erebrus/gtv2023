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
const MAIN_SCREEN = "res://src/world/levels/cemetery_1.tscn"
const GAMEOVER_SCREEN = "res://src/world/example.tscn"
const WIN_SCREEN = "res://src/win/win_screen.tscn"

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
	

func fade_in_audio(audio, period):
	if not audio:
		Logger.warn("can't find audio")
		return
	var ori_volume = audio.volume_db
	audio.volume_db = -80
	audio.play()
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).\
		tween_property(audio, "volume_db", ori_volume, period)

func fade_out_audio(audio, period):
	if not audio:
		Logger.warn("can't find audio")
		return
	var ori_volume = audio.volume_db	
	await create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).\
		tween_property(audio, "volume_db", ori_volume, period).finished		
	audio.stop()
	audio.volume_db = ori_volume
	


func start_menu_music()->void:
	if $music.playing:
		await fade_out_audio($music,.5)
	if not $menu_music.playing:
		fade_in_audio($menu_music, 1)
			
func start_game_music()->void:
	if $menu_music.playing:
		await fade_out_audio($menu_music,.5)
	if not $music.playing:
		fade_in_audio($music, 2)

func start_ambience()->void:
	if not $ambience.playing:
		fade_in_audio($ambience, .5)

func stop_ambience():
	$ambience.stop()		

func stop_game_music()->void:
	$music.stop()
	game_music_on = false
		
func _init_logger():

	Logger.set_logger_level(Logger.LOG_LEVEL_DEBUG)
	Logger.set_logger_format(Logger.LOG_FORMAT_MORE)
	var file_appender:Appender = Logger.add_appender(FileAppender.new("res://debug.log"))
	file_appender.logger_format=Logger.LOG_FORMAT_FULL
	file_appender.logger_level = Logger.LOG_LEVEL_TRACE


func gameover():
	Logger.info("player dead")
	await get_tree().create_timer(0.5).timeout
	level_manager.restore_checkpoint()
	

func win():
	SceneManager.change_scene(WIN_SCREEN)
	

func menu():
	SceneManager.change_scene(MENU_SCREEN)
	

func can_continue() -> bool:
	return level_manager.has_checkpoint()
	

func tutorial():
	level_manager.tutorial_level()
	_main_screen()
	

func start():
	level_manager.reset_level()
	

func continue_game():
	level_manager.restore_checkpoint()
	

func _main_screen():
	SceneManager.change_scene(MAIN_SCREEN)
	start_game_music()
	


func _on_music_finished():
	if game_music_on:
		start_game_music()
