extends CharacterBody2D



#const fixed_anims = ["hurt","death"]
signal health_changed
signal fired
signal jump_fired

@export var max_lives:int = 3:
	set(new_val):
		max_lives=new_val
		lives=new_val
@export  var disabled:bool = false
@export var recoil_force:float = 400.0
@export var attack_damage:float = 25.0
@export var attack_knockback:float = 50.0

var use_mouse:=true
var max_x:float = 0
var accel:float=0
var in_animation:bool = false
var last_y:float
var last_direction:=Vector2.RIGHT

var can_attack := true
var immune := false

@onready var sprite:AnimatedSprite2D = $sprite

@onready var controller = $platform_controller
@onready var direction_player:AnimationPlayer = $DirAnimationPlayer
@onready var lives:int = max_lives
#@onready var reload_timer = $reload_timer
@onready var climb_rc = $climb_rc
@onready var xsm = $xsm


@onready var timer_fs = $sfx/timer_fs
#@onready var sfx_hurt := $sfx/hurt
#@onready var sfx_death := $sfx/death
@onready var sfx_run := $sfx/run
@onready var sfx_jump := $sfx/jump
@onready var sfx_landing := $sfx/land


var can_play_footstep:bool = true

var dead:=false



func _ready():

	last_y=global_position.y
	last_direction=Vector2.RIGHT
	$DirAnimationPlayer.play("right")
#	setup_debug(true)
	xsm.change_state("idle")
	

#func setup_debug(val:bool):
#	if val:
#		HyperLog.log(self).text("global_position>%0.2f")
#		HyperLog.log(self).text("velocity>%0.2f")
#		HyperLog.log(self).text("accel>%0.2f")
#		HyperLog.log(self).offset(Vector2(32,-50))
#	else:
#		HyperLog.remove_log(self)


func update_sprite():
	
	var facing_direction = Vector2(sign(Input.get_axis("ui_left", "ui_right")),0)
	

	if facing_direction != Vector2.ZERO and facing_direction != last_direction:		
		last_direction = facing_direction
		var desired_direction = "right" if facing_direction.x > 0 else "left"
		if desired_direction != direction_player.current_animation:
			direction_player.play(desired_direction)
			
	

func play_animation(anim:String):
	if not sprite.is_playing() or sprite.animation!=anim:	
		sprite.play(anim)
	

func control(_delta:float) -> void:
	if in_animation:
		return
	if Input.is_action_just_pressed("jump"):
		Logger.debug("Jump was pressed. (global, should be processed by now) . "  )
	



func on_dash() -> void:
	pass

	
func on_walk_stop() -> void:
#	sfx_run.stop()
	pass
	
func on_walk() -> void:	
	if sfx_run == null:
		return
	if not sfx_run.playing and can_play_footstep:
		sfx_run.play()
		if timer_fs.wait_time>0:
			can_play_footstep = false
			timer_fs.start()


func on_jump() -> void:
	if sfx_jump == null:
		return
	sfx_jump.play()

	# create a rising cloud effect where the player jumps
#	var cloud = vfx_jump.instance() 
#	cloud.position = position
#	get_parent().add_child(cloud)


func on_landing(_last_vy:float):
	if sfx_landing == null:
		return
	sfx_landing.play()

func _process(delta: float) -> void:
	
	control(delta)
	
	if not in_animation: # we need the check in case we got into animation in control
		update_sprite()
		
#
#func environment_death():
#
#	#no longer death
#	if dead or immune:
#		return
#	lives-=1
#	if not check_for_death() or not get_parent().last_checkpoint_position:
#		xsm.change_state("Hurt")
#		velocity.x=0
#		immune=true
#		await get_tree().create_timer(.5).timeout
#		immune=false
#		global_position = get_parent().last_checkpoint_position
#
#
#	emit_signal("health_changed")
	

func _on_FootstepTimer_timeout():
	can_play_footstep=true


#func on_attacked(dmg):
#
#	Logger.info("player was attacked")
#	lives-=1
#	if not check_for_death():
#		xsm.change_state("Hurt")
#	emit_signal("health_changed")

	
func check_for_death():
	Logger.info("checking death: lives %d" % lives)
	if lives==0:
		collision_layer=0
		dead=true
		xsm.change_state("Death")
		return true
	return false


#func set_collision_enabled(val):
#	disabled = !false
#	$CollisionShape2D.disabled= !val
#	if val:
#		collision_layer=4
#	else:
#		collision_layer=0


	




func stop_animation():
	sprite.playing=false


func start_animation():
	sprite.playing=true


#func set_platform_collision_enabled(val):
#	if val:
#		collision_layer=4
#		collision_mask=3	
#	else:
#		collision_layer=0
#		collision_mask=0	


func is_climb_rc_colliding()->bool:
	climb_rc.force_raycast_update()
	return climb_rc.is_colliding()
	

func _input(event):
	if event is InputEventMouseMotion:
		use_mouse=true


func _on_timer_fs_timeout():	
	pass # Replace with function body.
