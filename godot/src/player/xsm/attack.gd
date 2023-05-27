@tool
extends StateAnimation

@export var attack_delay:float=.2
@export var attack_duration:float=.2
@export var lunge_distance:float=0
@export var extra_impulse:float = 0
#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

# This additionnal callback allows you to act at the end
# of an animation (after the nb of times it should play)
# If looping, is called after each loop
func _on_anim_finished(_name: String) -> void:
	if owner.is_on_floor():
		if Input.get_axis("ui_left","ui_right") != 0:
			change_state("move")
		else:
			change_state("Idle")
	else:
		change_state("Fall")


# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:

	owner.velocity.x=0
	owner.sfx_attack.play()
	if lunge_distance > 0 :
		lunge()
#		var tween = owner.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
##		var origin = owner.global_position
#		var dest = owner.global_position+Vector2(lunge_distance,0)*owner.last_direction
#		tween.tween_property(owner, "global_position", dest, .3)	
	if attack_delay>0:
		add_timer("attack_delay", attack_delay)
	else:
		owner.set_attack_box_enabled(true)



func lunge():	
	var new_position = owner.global_position+lunge_distance*owner.last_direction
	var x=new_position.x
	for y in range(40,160,10):
		
		var ray_params = PhysicsRayQueryParameters2D.new()
		var y_delta:Vector2 = Vector2(0,-y)
		ray_params.from = owner.global_position + y_delta
		ray_params.to = new_position + y_delta
		ray_params.exclude=[owner]
		var collision = owner.get_world_2d().direct_space_state.intersect_ray(ray_params)
		
		if collision:
			if abs(collision.position.x-owner.global_position.x) < abs(x- owner.global_position.x):
				x=collision.position.x

	new_position.x = x
	owner.in_animation=true
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	var dist = abs(new_position.x - owner.global_position.x)
	Logger.info("attack dash distance=%2f" % dist)
	var t = dist / owner.controller.max_speed
	tween.tween_property(owner, "global_position",new_position, t)		
	await tween.finished	
	owner.in_animation=false
# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	if extra_impulse:
		owner.apply_impulse(owner.last_direction*extra_impulse)


# This function is called each frame after all the update calls
# XSM after_updates the children first, then the root
func _after_update(_delta: float) -> void:
	pass


# This function is called before the State exits
# XSM before_exits the root first, then the children
func _before_exit(_args) -> void:
	pass


# This function is called when the State exits
# XSM before_exits the children first, then the root
func _on_exit(_args) -> void:
	owner.set_attack_box_enabled(false)
	owner.reload_timer.start()


# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	if _name=="attack_delay":
		owner.set_attack_box_enabled(true)
		add_timer("attack_duration",attack_duration)
	if _name=="attack_duration":
		owner.set_attack_box_enabled(false)	

	
