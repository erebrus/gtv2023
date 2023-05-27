extends Node2D

@export var period:float = 20
@export var enemy_scene:PackedScene 
@export var current_enemy:Enemy

@onready var timer:Timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	assert(enemy_scene)
	timer.wait_time = period
	if not current_enemy:
		timer.start()
	else:
		current_enemy.died.connect(_on_enemy_died)
	

func _on_enemy_died():
	timer.start()
	current_enemy = null
	


func _on_timer_timeout():
	current_enemy = enemy_scene.instantiate()
	get_parent().add_child(current_enemy)
	current_enemy.global_position = global_position
	current_enemy.died.connect(_on_enemy_died)
