@tool
extends StaticBody2D

const  CROSS_DURATION:= 1
@export var flip_h:=false:
	set(val):
		$Sprite2D.flip_h=val
	get:
		return $Sprite2D.flip_h
		

@onready var sprite = $Sprite2D

var player
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.flip_h=flip_h
	Events.dimension_changed.connect(_on_dimension_changed)


func _on_dimension_changed(dimension):
	if dimension == Events.Dimension.MATERIAL:
		if player:
			player.unset_object(self)
		player = null
		$interact_area.monitoring = false
	else:
		$interact_area.monitoring = true
		

func interact():
	if not player:
		Logger.warn("%s tried to interact without player" % name)
		return
	player.in_animation=true
	var tween := create_tween().set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(player, "global_position", get_opposite_exit().global_position,CROSS_DURATION)
	tween.parallel().tween_property(player, "modulate", Color(1,1,1,.2), CROSS_DURATION/2.0).set_ease(Tween.EASE_OUT)
	tween.tween_property(player, "modulate", Color(1,1,1,1), CROSS_DURATION/2.0).set_ease(Tween.EASE_IN)
	player.xsm.change_state("crossing")
	await tween.finished
	player.in_animation=false

func get_opposite_exit()->Node2D:
	var d1 = abs($exit_1.global_position.x-player.global_position.x	)
	var d2 = abs($exit_2.global_position.x-player.global_position.x	)
	return $exit_1 if d1>d2 else $exit_2
	
func _on_interact_area_body_entered(body):
	body.set_object(self)
	player = body


func _on_interact_area_body_exited(body):
	body.unset_object(self)
	player = null
