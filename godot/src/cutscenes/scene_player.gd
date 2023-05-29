extends Node2D

@export var next_scene:PackedScene
@onready var text:=$CanvasLayer/ColorRect/MarginContainer/Label
@onready var text_bg:= $CanvasLayer/ColorRect
var last_one:=false
@onready var voice:= $voice
@onready var voice2:= $voice2

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.start_ambience()
	Globals.start_menu_music()
	last_one = $CanvasLayer/TextOverlay2.texture == null
	$voice.play()
	$AnimationPlayer.play("play")	
	await $AnimationPlayer.animation_finished
	$Timer.start()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		_on_timer_timeout()

func load_next_scene():
	Logger.info("Playing fadeout")
	$AnimationPlayer.play("fade_out")	
	await $AnimationPlayer.animation_finished	
#	$CanvasLayer/TextOverlay.visible = false
#	$CanvasLayer/TextOverlay2.visible = false
#	$CanvasLayer/FadeRect.modulate=Color.WHITE
	get_tree().change_scene_to_packed(next_scene)
	
	
func _on_timer_timeout():
	if last_one:
		load_next_scene()
	else:
		$Timer.stop()
		last_one = true
		$AnimationPlayer.play("play2")	
		$voice2.play()
		Logger.info("Playing play2")
		await $AnimationPlayer.animation_finished
		$Timer.start()
