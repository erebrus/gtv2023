extends Area2D

signal switched(value:bool)


@export var time := 10.0
var value := false


@onready var timer = $timer

func _ready():
	$timer.wait_time = time
	Events.dimension_changed.connect(_on_dimension_changed)
	

func _on_dimension_changed(dimension):
	
	if dimension != Events.Dimension.MATERIAL and value:
		_trigger()
	monitoring = dimension == Events.Dimension.MATERIAL
	

func _on_body_entered(body):
	if not timer.is_stopped():
		timer.stop()
		value=true
		$sprite.play("on")
		switched.emit(true)		


func _on_body_exited(body):
	if get_overlapping_bodies().is_empty():
		_trigger()
		
func _trigger():
	if time != 0:
		timer.start()


func _on_timer_timeout():
	$sprite.play("off")
	switched.emit(false)	
	value=false	
