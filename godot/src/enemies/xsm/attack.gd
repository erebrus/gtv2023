@tool
extends StateAnimation

@export var attack_delay:float=.2
#
# FUNCTIONS TO INHERIT IN YOUR STATES
#
var start_time=-1
# This additionnal callback allows you to act at the endxRX
# of an animation (after the nb of times it should play)
# If looping, is called after each loop
func _on_anim_finished(_name: String) -> void:
	change_state("patrol")


# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:

	owner.desired_velocity.x=0
	owner.set_attackbox_enabled(true)
	start_time=Time.get_ticks_msec()
	owner.sfx_attack.play()
	add_timer("attack_timer", attack_delay)
	
# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	pass		


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
	owner.set_attackbox_enabled(false)
	owner.reload_timer.start()

# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass


# Called when any other Timer times out
func _on_timeout(_name) -> void:


	if owner.is_on_enemy():
		if owner.target.has_method("on_attacked"):
			owner.target.on_attacked(owner.global_position, owner.attack_damage, owner.knockback)
		else:
			Logger.warn("%s tried to attack invalid target %s." % [owner.name, owner.target.name])
		owner.set_attackbox_enabled(false)

