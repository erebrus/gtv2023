@tool
extends StateAnimation

@export var attack_delay:float=.2
@export var lunge_distance:float = 0
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
	owner.in_animation = true
#	Logger.info("%s attacking at time %d" % [owner.name, Time.get_ticks_msec()])
	owner.desired_velocity.x=0
	start_time=Time.get_ticks_msec()	
	owner.sfx_attack.play()
	if lunge_distance > 0 :
		var tween = owner.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
#		var origin = owner.global_position
		var dest = owner.global_position+Vector2(lunge_distance,20)*owner.get_facing_direction()
		tween.tween_property(owner, "global_position", dest, .2)
	owner.target.on_attacked(owner.global_position, owner.attack_damage, owner.knockback)
#	add_timer("attack_timer", attack_delay)
	
# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	var sprite = owner.get_node("sprite")
#	Logger.info("anim: %s %d" % [sprite.animation, sprite.frame])
	
	


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
	Logger.info("%s exiting attack at time %d" % [owner.name, Time.get_ticks_msec()])
	owner.in_animation = false
	owner.reload_timer.start()
	owner.set_attackbox_enabled(false)

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

