@tool
extends StateAnimation

@export var step_duration:= 0.0
@export var step_pause:= 0.0
#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

# This additionnal callback allows you to act at the end
# of an animation (after the nb of times it should play)
# If looping, is called after each loop
func _on_anim_finished(_name: String) -> void:
	pass


# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	var direction = owner.get_facing_direction()	
	if owner.is_must_turn():
		direction = -owner.get_facing_direction()	
		owner.velocity.x=direction.x
		owner.check_direction()		

	owner.desired_velocity=Vector2(owner.normal_speed,0)*direction
	
	if step_pause > 0:
		add_timer("pause", step_pause)


# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void: 
	owner.handle_run_sfx()
	if owner.target:
		var pos = owner.global_position.x
		var tpos = owner.target.global_position.x
		var enemy_direction = Vector2(sign(tpos-pos),0)
		if enemy_direction != owner.get_facing_direction():
			owner.velocity.x=0
			owner.desired_velocity.x=0
			owner.flip_direction()
		change_state("engage")		
	elif owner.is_must_turn():
		change_state("lookout")
	else:
		owner.desired_velocity=Vector2(owner.normal_speed,0)*owner.get_facing_direction()
		


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
	owner.sfx_run.stop()
	del_timers()


# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	if _name == "step" and step_pause!=0:
		owner.desired_velocity=Vector2.ZERO
		add_timer("pause", step_pause)
	if _name == "pause":
		owner.desired_velocity=Vector2(owner.normal_speed,0)*owner.get_facing_direction()	
		add_timer("step", step_duration)
