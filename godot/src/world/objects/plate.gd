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
	# freezing time disabled
#	timer.paused = dimension == Events.Dimension.SPECTRAL
		

func _on_body_entered(body):
	if not timer.is_stopped():
		timer.stop()
		Logger.debug("%s stopping timer" % name)
	Logger.debug("%s pressed" % name)
	value=true
	$sprite.play("on")
	$sfx_on.play()
	switched.emit(true)		


func _on_body_exited(body):
	if get_overlapping_bodies().is_empty():
		Logger.debug("%s unpressed. timer triggered" % name)
		_trigger()
		
func _trigger():
	if time != 0:
		timer.start()


func _on_timer_timeout():
	Logger.debug("%s is now off" % name)
	$sprite.play("off")
	$sfx_off.play()
	switched.emit(false)	
	value=false	
