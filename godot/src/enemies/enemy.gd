extends CharacterBody2D

const SOUL_SCENE=preload("res://src/enemies/soul.tscn")

@export var max_hp:int = 50
@export var normal_speed:float = 50
@export var engage_speed:float = 200
@export var  max_accel:float = 10.0
@export var attack_damage:float = 25
@export var knockback:float = 50
@export var dimension: Events.Dimension = Events.Dimension.SPECTRAL


var desired_velocity:=Vector2()

var target
var can_play_footstep:=true
@onready var hp:float =max_hp

@onready var timer_fs:Timer = $sfx/timer_fs
@onready var floor_rc:RayCast2D = $floor_rc
@onready var front_rc:RayCast2D = $front_rc
@onready var sprite:AnimatedSprite2D = $sprite
@onready var detection_box = $detection_box/CollisionShape2D
@onready var attack_box = $attack_box/CollisionShape2D
@onready var reload_timer = $reload_timer
@onready var xsm = $xsm
@onready var dir_player:AnimationPlayer = $DirAnimationPlayer
@onready var sfx_run = $sfx/run
@onready var sfx_hurt = $sfx/hurt
@onready var sfx_death = $sfx/death
@onready var sfx_attack = $sfx/attack
@onready var soul_trail = get_node_or_null("soul_trail")


var extra_impulse := Vector2.ZERO
@onready var original_position:Vector2 = global_position
var dead := false
#const G:float = 1000
var in_animation:bool = false

@export var th:=1.5
@export var h:= 300

#@onready var g:float = 2 * h / (th * th) # computed gravity
#@onready var v0:float = 2 * h / th # computed initial velocity	

var g:float = 2500.0
var v0:float = 750
func _ready()->void:
	Events.dimension_changed.connect(_on_dimension_changed)
	$sprite.play("idle")
	

func _on_dimension_changed(_dimension)->void:
	#TODO refactor
	if dimension == Events.Dimension.MATERIAL:
		if _dimension == Events.Dimension.MATERIAL:
			collision_layer=Globals.Layer.ENEMY
			$detection_box.monitoring = true
			$attack_box.monitoring = true
			sprite.visible = true
			if get_node_or_null("Polygon2D") != null:
				$Polygon2D.visible = true
			soul_trail.emitting = false
		else:
			soul_trail.emitting = true
			collision_layer=0
			$detection_box.monitoring = false
			$attack_box.monitoring = false
			sprite.visible = false
			if get_node_or_null("Polygon2D") != null:
				$Polygon2D.visible = false
	else:		
		if _dimension == Events.Dimension.MATERIAL:
			collision_layer=0
			$detection_box.monitoring = false
			$attack_box.monitoring = false
			sprite.visible = false
			if get_node_or_null("Polygon2D") != null:
				$Polygon2D.visible = false
		else:
			collision_layer=Globals.Layer.ENEMY
			$detection_box.monitoring = true
			$attack_box.monitoring = true
			sprite.visible = true
			if get_node_or_null("Polygon2D") != null:
				$Polygon2D.visible = true
			

func flip_direction():
	if $sprite.flip_h:
		dir_player.play("right")
	else:
		dir_player.play("left")

	
func get_facing_direction()->Vector2:

	if $sprite.flip_h: #needs to be direct reference because its used before ready
		return Vector2.LEFT
	else:
		return Vector2.RIGHT
		

func is_must_turn()->bool:
	var floor_below = floor_rc.is_colliding()
	var wall_in_front = front_rc.is_colliding()
	return not floor_below or wall_in_front

func check_direction():
	if not is_on_floor():
		return
	if velocity.x != 0 and sign(get_facing_direction().x) != sign(velocity.x):
		front_rc.target_position.x=-front_rc.target_position.x
		floor_rc.target_position.x=-floor_rc.target_position.x
		if velocity.x>0:
			dir_player.play("right")
		else:
			dir_player.play("left")


func _process(_delta: float) -> void:
	var was_on_floor = is_on_floor_only()
	if dead:
		return
	if in_animation:
		velocity += extra_impulse
		move_and_slide()
		if not is_on_floor():
			velocity.y+=g*_delta
		else:
			velocity.y=0
		extra_impulse = Vector2.ZERO
		if not was_on_floor and is_on_floor():
			desired_velocity.x=0
			velocity.x=0
		return
	check_direction()
	
	var delta_velocity = desired_velocity-velocity
	velocity += delta_velocity.normalized()*min(max_accel, delta_velocity.length())
	move_and_slide()
	if not was_on_floor and is_on_floor():
		velocity.x=0
		desired_velocity.x=0
#	dist_to_enemy=-1 if not target else global_position.distance_to(target.global_position)
	
#	var dvel = desired_velocity.length()	
	
	#Apply gravity if not on floor and not hanging
	if !is_on_floor():
		velocity.y += g*_delta
	else:
		velocity.y = 0 
	
	
func take_damage(source_pos, damage, _knockback):
	Logger.info("%s: take damage %d" % [name, damage])
	hp = clamp(hp-damage, 0, max_hp)
	Logger.info("%s: hp %d" % [name, hp])
	
	var tween 
	if _knockback > 0:
		var bounce_delta_x = Vector2(-(source_pos - global_position).x,0).normalized()*_knockback	
		var new_position = global_position+Vector2(bounce_delta_x.x,0)
		Logger.info("knockback %2f, ori pos=%s new_pos=%s" % [bounce_delta_x.x, global_position, new_position])
		var ray_params = PhysicsRayQueryParameters2D.new()
		var y_delta:Vector2 = Vector2(0,-10)
		ray_params.from = global_position + y_delta
		ray_params.to = new_position + y_delta
		ray_params.exclude=[self]
		var collision = get_world_2d().direct_space_state.intersect_ray(ray_params)
		
		if collision:
			new_position = collision.position 

		in_animation=true
		tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "global_position",new_position, .5)	
	
	if hp >0:
		Logger.info("%s hurt" % name)		
		Logger.info("Time %d" % Time.get_ticks_msec())
		xsm.change_state("hurt")
	else:
		Logger.info("%s dead" % name)
		Logger.info("Time %d" % Time.get_ticks_msec())
		dead=true		

		Logger.info("%s changing to death state" % name)
		xsm.change_state("death")
#		if tween:
#			await tween.finished
		return
	if tween:
		await tween.finished
	Logger.info("final pos %s" % global_position)
	in_animation=false


func on_target():
	pass
#	return  target and attack_box.get_parent().overlaps_body(target)




func attack():
	if not target or dead or xsm.is_active("attack"):
		return
	xsm.change_state("attack")


func spawn_soul():
	if dimension == Events.Dimension.SPECTRAL:
#		var soul = $soul
#		soul.get_parent().remove_child(soul)
#		get_parent().add_child(soul)
#		soul.anchor = global_position+Vector2(0,-50)			
#		soul.visible = true
#		soul.fade_in()
		var soul = SOUL_SCENE.instantiate()
		get_parent().add_child(soul)
		soul.anchor = global_position+Vector2(0,-50)	

func finish_death():
	collision_layer=0	
	set_process(false)
	await get_tree().create_timer(.2).timeout
	call_deferred("queue_free")
	
func is_on_enemy()->bool:
	return target and $attack_box.overlaps_body(target) #TODO proper ref

func handle_run_sfx():
	if not sfx_run.playing and can_play_footstep:
		sfx_run.play()
		if timer_fs.wait_time>0:
			can_play_footstep = false
			timer_fs.start()


func _on_timer_fs_timeout():
	can_play_footstep=true


func _on_detection_box_body_entered(body):
	if body.is_in_group("player"):
		target = body


func _on_detection_box_body_exited(body):
	if body.is_in_group("player"):
		target = null


func _on_attack_box_body_entered(body):
	if body.is_in_group("player"):
		attack()

func set_attackbox_enabled(val):
	Logger.info(" attack box %s" % val)
	attack_box.disabled=!val


func _on_reload_timer_timeout():
	Logger.debug("reload sets attack box true")
	set_attackbox_enabled(true)

func play_animation(anim:String):
	if not sprite.is_playing() or sprite.animation != anim:
		sprite.play(anim)

func can_attack():
	return reload_timer.is_stopped()


func apply_impulse(impulse:Vector2):
	extra_impulse += impulse
