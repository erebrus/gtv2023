@tool
extends StateAnimation


var collision_direction:Vector2
var t
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
		owner.sfx_climb.play()
		await owner.sfx_climb.finished
		if owner.floor_type == Map.FloorType.GRASS:
			owner.sfx_climb_slide.play()
		else:
			owner.sfx_climb_slide_rock.play()
#		Logger.info("Climb collision count=%d" % owner.get_slide_count())
#		for i in owner.get_slide_count():
#			Logger.info("Collision %d - %s" % [i, owner.get_slide_collision(i).normal])
		var collision:KinematicCollision2D = owner.get_last_slide_collision()
		collision_direction = -collision.get_normal()
		t = add_timer("climb_hangtime",owner.controller.climb_timeout)
		var axis_x:float = Input.get_axis("ui_left", "ui_right")
		Logger.debug("Entering climb because direction %2f vs %2f " % [axis_x, collision_direction.x])


# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:

	if not owner.is_climb_rc_colliding():# or sign(input.x) != sign(collision_direction.x) or :
		Logger.debug("Stop Climb because of direction")
		change_state("fall")
	else:
		owner.velocity.y=0
	if owner.controller.processing_jump and owner.controller.allow_wall_jump:	
	#if Input.is_action_just_pressed("jump") and owner.controller.allow_wall_jump:		
		Logger.trace("jump from climb")
		owner.controller.do_jump(-collision_direction)

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
	if t:
		t.stop()
		t=null
	owner.sfx_climb_slide.stop()
	owner.sfx_climb_slide_rock.stop()
	owner.controller.can_climb=false
	owner.controller.climb_reload_timer.start()


# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	Logger.debug("Stop climb because of timeout")
	change_state("fall")
