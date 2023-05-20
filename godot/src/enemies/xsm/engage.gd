@tool
extends StateAnimation

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
	owner.set_attackbox_enabled(true)

# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	if not owner.target:
		change_state("patrol")
		return
	
	owner.handle_run_sfx()
	var player=owner	
	var tpos = owner.target.global_position.x 
	var ppos = owner.global_position
	var target_direction = Vector2(sign(owner.target.global_position.x - owner.global_position.x),0)
	#if target_direction != owner.get_facing_direction()
	
	if owner.is_must_turn():
		owner.desired_velocity.x=0
	else:		
		owner.desired_velocity.x=owner.engage_speed*target_direction.x
	


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


# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	pass
