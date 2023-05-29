extends Node2D

@export var next_scene:PackedScene
@onready var text:=$CanvasLayer/ColorRect/MarginContainer/Label
@onready var text_bg:= $CanvasLayer/ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("play")	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		load_next_scene()

func load_next_scene():
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_packed(next_scene)
	
	
func _on_timer_timeout():
	load_next_scene()
