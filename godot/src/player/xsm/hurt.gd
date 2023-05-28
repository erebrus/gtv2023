@tool
extends StateAnimation

@export var do_slomo := false
var tween  
#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

# This additionnal callback allows you to act at the end
# of an animation (after the nb of times it should play)
# If looping, is called after each loop
func _on_anim_finished(_name):
	if owner.dimension == Events.Dimension.MATERIAL:
		owner.shift(true)
	else:
		change_state("idle")


# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args):
	if owner.dimension == Events.Dimension.MATERIAL:
		owner.sfx_hurt.play()	
	else:
		owner.sfx_hurt_spectral.play()	
	if do_slomo:
		tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(Engine, "time_scale", .5,.1)


# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args):
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta):
	pass


# This function is called each frame after all the update calls
# XSM after_updates the children first, then the root
func _after_update(_delta):
	pass

# This function is called before the State exits
# XSM before_exits the root first, then the children
func _before_exit(_args):
	pass


# This function is called when the State exits
# XSM before_exits the children first, then the root
func _on_exit(_args):
	if do_slomo:
		Engine.time_scale = 1


# when StateAutomaticTimer timeout()
func _state_timeout():
	pass


# Called when any other Timer times out
func _on_timeout(_name):
	pass

