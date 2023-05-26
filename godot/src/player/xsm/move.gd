@tool
extends StateAnimation


var checking_fall:=false

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
	checking_fall = false
	owner.controller.air_jump_count = 0


# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	#if we are moving,	but there is no input
	if owner.controller.processing_jump:
		Logger.debug("Jump in walk")
		owner.controller.do_jump()
		return
	if not owner.is_on_floor() and not checking_fall:
		add_timer("check_fall",.1)
	if abs(owner.velocity.x) < .1:
		change_state("idle")
	owner.on_walk()
	owner.play_animation("move")


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
	pass


# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	if _name=="check_fall":
		if not owner.is_on_floor():
			change_state("fall")
		checking_fall = false
