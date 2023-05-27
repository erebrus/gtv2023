@tool
extends StateAnimation


@export var charge_time:float = 1.0

var lunging:=false
#
# FUNCTIONS TO INHERIT IN YOUR STATES
#
# This additionnal callback allows you to act at the endxRX
# of an animation (after the nb of times it should play)
# If looping, is called after each loop
func _on_anim_finished(_name: String) -> void:
	pass


# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args):
	lunging=false
	owner.velocity.x=0
	owner.desired_velocity.x=0
	if owner.target!= null and is_instance_valid(owner.target):
		ensure_direction()
	add_timer("charge",charge_time)


func ensure_direction():	
	var pos = owner.global_position.x
	var tpos = owner.target.global_position.x
	var enemy_direction = Vector2(sign(tpos-pos),0)
	if enemy_direction != owner.get_facing_direction():
		owner.flip_direction()

# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args):
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta):
	if lunging and owner.is_on_floor():
		change_state("patrol")
	elif not lunging:
		owner.velocity.x=0
	else:
		if target != null:
			ensure_direction()
#	owner.apply_impulse(Vector2(0,-owner.G*.9999))


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
	owner.in_animation = false
	owner.velocity.x=0


# when StateAutomaticTimer timeout()
func _state_timeout():
	pass


# Called when any other Timer times out
func _on_timeout(_name):
	owner.in_animation = true
	owner.apply_impulse(Vector2(1000,-owner.v0))
	lunging=true

