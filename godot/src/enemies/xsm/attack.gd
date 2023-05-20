@tool
extends StateAnimation

@export var attack_delay_msecs:int=500
#
# FUNCTIONS TO INHERIT IN YOUR STATES
#
var character_node
var start_time=-1
# This additionnal callback allows you to act at the end
# of an animation (after the nb of times it should play)
# If looping, is called after each loop
func _on_anim_finished(_name: String) -> void:
	change_state("patrol")


# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	character_node= owner
	owner.desired_velocity.x=0
	owner.set_attackbox_enabled(true)
	start_time=Time.get_ticks_msec()
	owner.sfx_attack.play()
	
# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
		
	var now=Time.get_ticks_msec()
	if now-start_time>attack_delay_msecs:
		var p=character_node
		if character_node.has_method("is_on_enemy"):
			if character_node.is_on_enemy():
				if character_node.target.has_method("on_attacked"):
					character_node.target.on_attacked(owner.attack_damage)
				else:
					Logger.warn("%s tried to attack invalid target %s." % [character_node.name, character_node.target.name])
				character_node.set_attackbox_enabled(false)
		else:
			Logger.warn("is_on_enemy failing.")

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
	pass
