@tool
extends StateAnimation

@export var min_distance:=20.0
@export var charge_time:=1.0
@export var animation_speed_factor:=2.0
@export var direct_attack_distance:float = 0
var moving:=false
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
	owner.sprite.speed_scale=1.0
	moving = false
	var dist = abs ( owner.target.global_position.x - owner.global_position.x)
	if charge_time > 0 and dist > min_distance:
		add_timer("charge", charge_time)
	else:
		moving = true
		owner.play_animation("move")
		owner.sprite.speed_scale=animation_speed_factor
		

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

	var target_direction = Vector2(sign(owner.target.global_position.x - owner.global_position.x),0)
	var dist = abs ( owner.target.global_position.x - owner.global_position.x)
	if direct_attack_distance and dist<=direct_attack_distance:
		Logger.debug("%s direct attack at %d" % [owner.name, Time.get_ticks_msec()])
		change_state("attack")
	
	if moving:
		owner.handle_run_sfx()		
		if owner.is_must_turn():
			owner.desired_velocity.x=0
		else:		
			owner.desired_velocity.x=owner.engage_speed*target_direction.x
	else:
		owner.desired_velocity.x=0
		if sign(owner.get_facing_direction().x) != sign(target_direction.x):
			owner.sprite.flip_h = not owner.sprite.flip_h
		
	


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
	owner.sprite.speed_scale=1.0
	del_timer("charge")

# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	if _name == "charge":
		owner.play_animation("move")
		moving = true
		owner.sprite.speed_scale=animation_speed_factor
