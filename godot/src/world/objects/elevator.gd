extends CharacterBody2D

@export var y_delta:float=128*10
@export var speed:=100
@export var start_up:bool = false

var pending:=false
var direction:=Vector2.DOWN
var in_animation:=false
var ori_position:Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	ori_position = global_position
	if start_up:
		direction=Vector2.UP
		global_position = ori_position+Vector2.UP*y_delta


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if in_animation:
		velocity=direction*speed
		var tv=velocity
		move_and_slide()
		if direction==Vector2.UP:
			var destination = ori_position + Vector2.UP * y_delta
			if global_position.y <= destination.y:
				global_position = destination
				in_animation=false
		else:
			var destination = ori_position
			if global_position.y >= destination.y:
				global_position = destination
				in_animation=false
	elif pending:
		pending = false
		flip()
	
			
func _on_switched(val:bool,muted:=false)->void:
	if in_animation:
		pending=true
	else:
		flip(muted)
	
func flip(muted:=false):
	direction*=-1
	in_animation=true
	
	
		
