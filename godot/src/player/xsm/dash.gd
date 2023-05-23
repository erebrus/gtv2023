@tool
extends StateAnimation


#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

# This additionnal callback allows you to act at the end
# of an animation (after the nb of times it should play)
# If looping, is called after each loop
func _on_anim_finished(_name):
	pass


# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args):
	owner.controller.hanging = true   
	var input:Vector2 = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	owner.controller.do_dash(input)
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_property(owner, "velocity", Vector2.ZERO, owner.controller.dash_hangtime)
	await tween.finished
	change_state("fall")

# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args):
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta):
	pass
#	owner.velocity.y = 0
#	var x_input:float = Input.get_axis("ui_left","ui_right")
#	if abs(owner.velocity.x) < .1: #or sign(owner.velocity.x) != sign(x_input)
#		change_state("fall")
	


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
	owner.controller.hanging = false
	


# when StateAutomaticTimer timeout()
func _state_timeout():
	pass


# Called when any other Timer times out
func _on_timeout(_name):
	pass

