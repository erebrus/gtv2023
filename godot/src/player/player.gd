extends CharacterBody2D


const multi_state_anims = ["idle", "move", "jump", "fall", "hurt", "attack"]

signal health_changed
signal fired
signal jump_fired

@export var max_energy:float = 100
@export var energy_decay:float = 5
@export var decay_threshold:float = 10
@export  var disabled:bool = false
@export var recoil_force:float = 400.0
@export var attack_damage:float = 25.0
@export var attack_knockback:float = 50.0
@export var spectral_th:float = 1.6
@export var material_th:float = .6

var use_mouse:=true
var max_x:float = 0
var accel:float=0
var in_animation:bool = false
var last_y:float
var last_direction:=Vector2.RIGHT

var can_attack := true
var immune := false
@onready var energy:float = max_energy:
	set(_energy):
		energy = _energy
		Events.soul_meter_changed.emit(energy/max_energy)
		if energy <= decay_threshold and dimension==Events.Dimension.MATERIAL:
			shift()
			return
			
	
@onready var sprite:AnimatedSprite2D = $sprite

var controller
@onready var direction_player:AnimationPlayer = $DirAnimationPlayer
@onready var reload_timer = $reload_timer
@onready var climb_rc = $climb_rc
@onready var xsm = $xsm
@onready var attack_box =$attack_box

@onready var timer_fs = $sfx/timer_fs
@onready var sfx_hurt := $sfx/hurt
@onready var sfx_death := $sfx/death
@onready var sfx_run := $sfx/run
@onready var sfx_jump := $sfx/jump
@onready var sfx_landing := $sfx/land
@onready var sfx_attack := $sfx/attack


var can_play_footstep:bool = true

var dead:=false
var dimension = Events.Dimension.SPECTRAL

var extra_impulse := Vector2.ZERO
var object
	
		

func _ready():
	if dimension == Events.Dimension.MATERIAL:
		controller = $material_controller
		$material_controller.set_process(true)
		$spectral_controller.set_process(false)
	else:
		controller = $spectral_controller
		$material_controller.set_process(false)
		$spectral_controller.set_process(true)
		
	last_y=global_position.y
	last_direction=Vector2.RIGHT
	$DirAnimationPlayer.play("right")
#	setup_debug(true)
	xsm.change_state("idle")
	Events.dimension_changed.connect(_on_dimension_changed)

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
	if xsm.is_active("move"):
		$CollisionShape2D.position.x=24 * facing_direction.x
	else:
		$CollisionShape2D.position.x=0
			
	

func play_animation(anim:String, force:=false):
	if anim in multi_state_anims:
		if dimension ==Events.Dimension.SPECTRAL:
			anim += "_spectral"
#	if not sprite.is_playing() or sprite.animation != anim:
	if sprite.animation != anim or force:		
		Logger.info("playing %s (before playing=%s, current anim %s)" % [anim, sprite.is_playing(), sprite.animation])
		sprite.play(anim)
	
func shift():
	if dimension == Events.Dimension.MATERIAL:
		Events.dimension_changed.emit(Events.Dimension.SPECTRAL)
	else:
		Events.dimension_changed.emit(Events.Dimension.MATERIAL)

func control(_delta:float) -> void:
	if in_animation:
		return
	if Input.is_action_just_pressed("jump"):
		if dimension == Events.Dimension.MATERIAL:
			Logger.debug("Jump was pressed. (global, should be processed by now) . "  )
		
	
	if Input.is_action_just_pressed("shift"):
		shift()


func _on_dimension_changed(_dimension):
	if _dimension == dimension:
		return
	dimension = _dimension
	if _dimension == Events.Dimension.MATERIAL:
		xsm.change_state("materialise")	
		controller = $material_controller
		$material_controller.set_process(true)
		$spectral_controller.set_process(false)
	else:
		xsm.change_state("decay")	
		controller = $spectral_controller
		$material_controller.set_process(false)
		$spectral_controller.set_process(true)
		
		
	
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
	if dimension == Events.Dimension.MATERIAL:
		self.energy = clamp(energy-energy_decay*delta, 0, max_energy)
	
#	if is_on_floor() and xsm.is_active("can_dash"):
#		controller.can_dash = true
		
	control(delta)
	
	if not in_animation: # we need the check in case we got into animation in control
		update_sprite()

func check_and_handle_collisions():
	pass
#
#	var last_collision := get_last_slide_collision()
#	if not last_collision:
#		return
#
#	if last_collision.get_collider().is_in_group("enemy"):
##		var normal = ($CollisionShape2D.global_position-last_collision.get_collider().get_node("CollisionShape2D").global_position).normalized()
#		#var normal = ($CollisionShape2D.global_position-last_collision.get_collider().get_node("CollisionShape2D").global_position).normalized()
#		var bounce_angle:Vector2 = Vector2.RIGHT.rotated(-PI/6)
#		if global_position < last_collision.get_collider().global_position: 
#			bounce_angle.x = -bounce_angle.x
#		bounce(bounce_angle,600)


	
#func environment_death():
#
#	#no longer death
#	if dead or immune:
#		return
#	lives-=1
#	if not check_for_death() or not get_parent().last_checkpoint_position:
#		xsm.change_state("hurt")
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

func bounce(direction, distance):
	var tmp_V = velocity
	velocity=direction*distance
	tmp_V = velocity
	in_animation=true

	await get_tree().create_timer(.4).timeout
	
	in_animation=false
	
#	var tween 
#	if distance <= 0:
#		return
#
#	var old_pos = global_position
#	var new_position = global_position+direction*distance
#
##		Logger.info("knockback %2f, ori pos=%s new_pos=%s" % [bounce_delta_x.x, global_position, new_position])
#	var ray_params = PhysicsRayQueryParameters2D.new()
#	var y_delta:Vector2 = Vector2(0,-10)
#	ray_params.from = global_position + y_delta
#	ray_params.to = new_position + y_delta
#	ray_params.exclude=[self]
#	var collision = get_world_2d().direct_space_state.intersect_ray(ray_params)
#
#	if collision:
#		new_position = collision.position 
#
#	in_animation=true
#	collision_layer -= Globals.Layer.ENEMY
#	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
#	tween.tween_property(self, "global_position",new_position, .5)	
#
#	await tween.finished
#	collision_layer += Globals.Layer.ENEMY
#	in_animation=false
		
func on_attacked(source_pos:Vector2, dmg:float, knockback:float = 0):

	Logger.debug("player was attacked")
	if not check_for_death():
		xsm.change_state("hurt")	
	if knockback > 0:
		var bounce_angle:Vector2 = Vector2.RIGHT.rotated(-PI/6)
		if global_position.x < source_pos.x: 
			bounce_angle.x = -bounce_angle.x
		bounce(bounce_angle,600)	
	self.energy = clamp(energy-dmg, 0, max_energy)
	
	emit_signal("health_changed")


#
#	var tween 
#	if knockback > 0:
#		var bounce_delta_x = Vector2(-(source_pos - global_position).x,0).normalized()*knockback	
#		var new_position = global_position+Vector2(bounce_delta_x.x,0)
#		Logger.info("knockback %2f, ori pos=%s new_pos=%s" % [bounce_delta_x.x, global_position, new_position])
#		var ray_params = PhysicsRayQueryParameters2D.new()
#		var y_delta:Vector2 = Vector2(0,-10)
#		ray_params.from = global_position + y_delta
#		ray_params.to = new_position + y_delta
#		ray_params.exclude=[self]
#		var collision = get_world_2d().direct_space_state.intersect_ray(ray_params)
#
#		if collision:
#			new_position = collision.position 
#
#		in_animation=true
#		tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
#		tween.tween_property(self, "global_position",new_position, .5)	
	
#	if not check_for_death():		
#		xsm.change_state("hurt")
#
#	emit_signal("health_changed")	
#	if tween:
#		await tween.finished
#	in_animation=false
	
		





	
func check_for_death():
	Logger.info("checking death: energy %2f" % energy)
	if energy==0:
		collision_layer=0
		dead=true
		xsm.change_state("death")
		return true
	return false


func set_collision_enabled(val):
	disabled = !false
	$CollisionShape2D.disabled= !val
	if val:
		collision_layer=4
	else:
		collision_layer=0


func stop_animation():
	sprite.playing=false


func start_animation():
	sprite.playing=true


func is_climb_rc_colliding()->bool:
	climb_rc.force_raycast_update()
	return climb_rc.is_colliding()
	

func _input(event):
	if event is InputEventMouseMotion:
		use_mouse=true


func _on_timer_fs_timeout():	
	can_play_footstep=true


func set_object(_obj):
	object = _obj
	
func unset_object(_obj):
	if object == _obj:
		object = null

func interact():
	if object:
		object.interact()
		
func on_environment_damage():
	if dimension == Events.Dimension.MATERIAL:
		Events.dimension_changed.emit(Events.Dimension.SPECTRAL)
	
func set_attack_box_enabled(val:bool)->void:
	#attack_box.monitoring = val
	$attack_box/CollisionShape2D.disabled = not val

func _on_attack_box_body_entered(body):
	if body.has_method("take_damage"):
		Logger.info("attack contact at %d" % Time.get_ticks_msec())
		body.take_damage(global_position, attack_damage, attack_knockback)


func _on_reload_timer_timeout():
	can_attack = true

func consume(soul):
	self.energy = clamp(energy+ soul.energy, 0, max_energy)


func apply_impulse(impulse:Vector2):
	extra_impulse += impulse
	
