extends CharacterBody2D

signal died
enum State {Flying, Hovering}
 
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
@export var travel_distance := 1920.0
@export var travel_speed := 300.0
var target: Vector2
var state := State.Hovering
var current_anchor

func _ready():
	Events.dimension_changed.connect(_on_dimension_changed)
	fade_in(false)
	_on_timer_timeout()
		

func _on_dimension_changed(_dimension):
	if _dimension == Events.Dimension.MATERIAL:
		visible = false
		$soul.monitoring = false
	else:
		visible = true
		$soul.monitoring = true
		
func set_target() -> bool:
	var targets:Array = []
	target = global_position
	for t in get_tree().get_nodes_in_group("soul_anchor"):
		var dist = abs(global_position.x - t.global_position.x)
		if dist<travel_distance\
			and dist > 78\
			and t.soul == null: 				
				targets.append(t)
	if not targets.is_empty():
		var t = RngUtils.array(targets, 1)[0]
		target = t.global_position + Vector2(RngUtils.float_range(-64,64),RngUtils.float_range(-64,64))
		Logger.debug("%s choosing target %s" % [name, target])
		if current_anchor:
			current_anchor.soul = null
		current_anchor=t
		current_anchor.soul= self
		return true
	else:
		Logger.debug("% no soul anchor found. Trying again later" % name)
		$Timer.start()
		return false
		
	
	
func _process(delta):
	if state == State.Flying:
		if global_position.distance_to(target) <= travel_speed * delta:
			anchor=global_position
			state=State.Hovering
			$Timer.wait_time = RngUtils.float_range(5,10)
			$Timer.start()
			
		velocity = global_position.direction_to(target) * travel_speed
		var tv = velocity
		var gp = global_position
		move_and_slide()		
	else:
		var period = Time.get_ticks_msec()/200.0+seed_delta
		position.y = anchor.y + sin(period)* y_amplitude
		
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
	$soul/sfx_consume.play()
	player.play("fade_out")
#	await tween.finished
	await player.animation_finished
	died.emit()
	call_deferred("queue_free")



func _on_timer_timeout():
	if set_target():
		state = State.Flying
