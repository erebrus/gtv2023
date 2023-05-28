extends Node2D


const SOUL_SCENE=preload("res://src/enemies/soul.tscn")

@export var min_period:=10.0
@export var max_period:=30.0

var current_soul


@onready var timer:Timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	Events.dimension_changed.connect(_on_dimension_changed)
	schedule_spawn()

func _on_dimension_changed(_dimension):
	if _dimension == Events.Dimension.MATERIAL:
		visible = false
	else:
		visible = true
		
func schedule_spawn():
	timer.wait_time = RngUtils.float_range(min_period, max_period)	
	timer.start()
	current_soul = null

func _on_soul_died():
	schedule_spawn()		

func _on_timer_timeout():
	current_soul = SOUL_SCENE.instantiate()
	get_parent().add_child(current_soul)
	current_soul.global_position = global_position
	current_soul.died.connect(_on_soul_died)
	current_soul.visible = visible
	current_soul.get_node("soul").monitoring = visible
	

