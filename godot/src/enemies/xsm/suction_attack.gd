@tool
extends StateAnimation

@export var attack_delay:float=.2
@export var suction_duration:float=.2
@export var suction_strength:float=30
@export var min_distance:float=30


var do_suction := false
#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

# This additionnal callback allows you to act at the endxRX
# of an animation (after the nb of times it should play)
# If looping, is called after each loop
func _on_anim_finished(_name: String) -> void:
	change_state("patrol")


# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	do_suction = true
	owner.in_animation = true

	owner.desired_velocity.x=0
	owner.set_attackbox_enabled(true)	
	owner.sfx_attack.play()
	if suction_duration > 0:
		add_timer("suction_timer", suction_duration)
	add_timer("attack_timer", attack_delay)
	
# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	if not is_instance_valid(owner.target):
		return
	var x_dist = owner.target.global_position.x - owner.global_position.x
	if do_suction and abs(x_dist)>min_distance:		
		var impulse = Vector2(suction_strength,0)*sign(x_dist)*-1 
		owner.target.apply_impulse(impulse)
				


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
	do_suction = false
	owner.in_animation = false
	owner.set_attackbox_enabled(false)
	owner.reload_timer.start()
	del_timers()

# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass


# Called when any other Timer times out
func _on_timeout(_name) -> void:

	if _name == "suction_timer":
		do_suction = false
	elif _name == "attack_timer":
		if owner.is_on_enemy():
			if owner.target.has_method("on_attacked"):
				owner.target.on_attacked(owner.global_position, owner.attack_damage, owner.knockback)
			else:
				Logger.warn("%s tried to attack invalid target %s." % [owner.name, owner.target.name])
			owner.set_attackbox_enabled(false)

