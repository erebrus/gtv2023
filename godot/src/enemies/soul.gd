extends CharacterBody2D

signal died
 
@export var energy:=20.0
@onready var sfx := $soul/sfx_consume
@onready var player := $soul/AnimationPlayer

var y_amplitude := RngUtils.int_range(4,10)
var x_amplitude := RngUtils.float_range(.2,2)
var seed_delta:float = RngUtils.int_range(-100,100)
var x_speed:= 0.0
var direction:float = 1.0 if RngUtils.int_range(0,1)>0.0 else -1.0
@onready var anchor:Vector2  = global_position:
	set(_anchor):
		anchor = _anchor
		global_position = anchor
@export var travel_distance := Vector2(1920, 1080.0)
@export var travel_speed := 100.0
var target: Vector2
@onready var no_amp_pos := global_position


func _ready():
	Events.dimension_changed.connect(_on_dimension_changed)
	fade_in(false)
	set_target()

func _on_dimension_changed(_dimension):
	if _dimension == Events.Dimension.MATERIAL:
		visible = false
		$soul.monitoring = false
	else:
		visible = true
		$soul.monitoring = true
		
func set_target() -> void:
	target = Vector2(RngUtils.float_range(anchor.x - travel_distance.x / 2, anchor.x + travel_distance.x / 2), RngUtils.float_range(anchor.y - travel_distance.y / 2, anchor.y + travel_distance.y / 2))
	
	
func _process(delta):
	if no_amp_pos.distance_to(target) <= travel_speed * delta:
		set_target()
	var period = Time.get_ticks_msec()/200.0+seed_delta
	no_amp_pos += no_amp_pos.direction_to(target) * delta * travel_speed
	var target_pos := no_amp_pos + Vector2(0, sin(period)* y_amplitude)
	velocity = position.direction_to(target_pos) * travel_speed
	move_and_slide()
#	x_speed = sin(period)* .5 * direction
#	position.x += x_speed

func fade_in(mute:=false):
	player.play("fade_in")
	if not mute:
		$soul/sfx_spawn.play()
	await player.animation_finished
	player.play("hover")


func _on_soul_body_entered(body: Node2D) -> void:
	body.consume(self)
#	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
#	tween.tween_property(self, "modulate", Color(1,1,1,0),.3)
#	sfx.play()
	player.play("fade_out")
#	await tween.finished
	await player.animation_finished
	died.emit()
	call_deferred("queue_free")

