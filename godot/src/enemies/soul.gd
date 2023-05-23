extends Area2D

 
@export var energy:=20.0
@onready var sfx := $sfx_consume
@onready var player := $AnimationPlayer

var y_amplitude := RngUtils.int_range(4,10)
var x_amplitude := RngUtils.float_range(.2,2)
var seed_delta:float = RngUtils.int_range(-100,100)
var x_speed:= 0.0
var direction:float = 1.0 if RngUtils.int_range(0,1)>0 else -1
@onready var anchor:Vector2  = global_position:
	set(_anchor):
		anchor = _anchor
		global_position = anchor


func _ready():
	fade_in()
	
	
func _process(delta):
	var period = Time.get_ticks_msec()/200.0+seed_delta
	position.y = anchor.y + sin(period)* y_amplitude
#	x_speed = sin(period)* .5 * direction
#	position.x += x_speed

func fade_in():
	player.play("fade_in")
	await player.animation_finished
	player.play("hover")
	
func _on_body_entered(body):
	body.consume(self)
#	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
#	tween.tween_property(self, "modulate", Color(1,1,1,0),.3)
#	sfx.play()
	player.play("fade_out")
#	await tween.finished
	await player.animation_finished
	call_deferred("queue_free")
