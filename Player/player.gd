extends CharacterBody3D

enum PlayerState { None, Dash, Attack, AttackReturn }
enum AttackDir { Forward, Backward }

@onready var cam_pivot : Node3D = $CameraPivot
@onready var cam: Camera3D = $CameraPivot/Camera3D
@onready var model : Node3D = $Model

@export_category('Combat')
@export var ProjectileScene : PackedScene
var _curr_state : PlayerState = PlayerState.None
@onready var raycast : RayCast3D = $CameraPivot/Camera3D/RayCast3D
var _curr_attack_dir = AttackDir.Forward
var _buffered_state : PlayerState = PlayerState.None

@export_category('Movement')
@export var MoveSpeed = 10
@export var TurnSpeed = 720
@onready var _rad_turn_speed = deg_to_rad(TurnSpeed)
var _disable_movement = false
@export var DashModifier = 1.5
var _dash_dir : Vector3 = Vector3.ZERO


@export_category('Anims')
@onready var _leg_anims : AnimationPlayer = $LegAnimationPlayer
@onready var _arm_anims : AnimationPlayer = $Model/ArmAnimationPlayer


func _process(delta):
	# Hacky fs
	if _arm_anims.current_animation == '':
		_curr_state = PlayerState.None

	_handle_input(delta)
	var dir = _handle_movement(delta)

	if not _disable_movement:
		if _curr_state == PlayerState.Dash:
			velocity = _dash_dir * MoveSpeed * DashModifier
		else:
			velocity = dir * MoveSpeed
		_handle_anims(dir, delta)

		move_and_slide()
		apply_floor_snap()

func _handle_movement(_delta):
	var x = Input.get_axis('Left', 'Right')
	var z = Input.get_axis('Forward', 'Back')

	var b : Basis = cam_pivot.transform.basis
	var dir = (b.z * z + b.x * x).normalized()


	if Input.is_action_just_pressed('Dodge'):
		#if _curr_state == PlayerState.None:
			_curr_state = PlayerState.Dash
			_dash_dir = dir
			_leg_anims.play('dash')
			_arm_anims.play('dash')

	return dir

func _handle_anims(move_dir, delta):
	if _curr_state != PlayerState.Dash:
		var ang = model.basis.z.signed_angle_to(move_dir, Vector3.UP)

		if abs(ang) > _rad_turn_speed * delta:
			ang = sign(ang) * _rad_turn_speed * delta

		model.rotation.y += ang
	
	if move_dir.length() == 0: 
		_keep_leg_anim('idle')
		_keep_arm_anim('Idle')
	else: 
		_keep_leg_anim('run')
		_keep_arm_anim('Run')


func _handle_input(_delta):
	if Input.is_action_just_pressed('Fire'):
		if _curr_state == PlayerState.None:
			_arm_anims.play('ForwardSlash')
			_curr_state = PlayerState.Attack
		else:
			_buffered_state = PlayerState.Attack


func launch_projectile(target_pos:Vector3):
	var p = ProjectileScene.instantiate()
	get_parent().add_child(p)
	p.global_position = global_position + Vector3.UP

	p.launch(model.basis.z, target_pos)
	#p.launch(target_pos - global_position, target_pos)


func _keep_leg_anim(anim_name):
	if _leg_anims.current_animation == anim_name: return

	if _curr_state == PlayerState.Dash:
		return
	else:
		_leg_anims.play(anim_name)

func _keep_arm_anim(anim_name):
	if _arm_anims.current_animation == anim_name: return

	if _arm_anims.current_animation == "UnForwardSlash": return

	if _curr_state == PlayerState.None:
		_arm_anims.play(anim_name)


func _attack_anim_complete():
	if _buffered_state == PlayerState.Attack:
		if _curr_attack_dir == AttackDir.Forward:
			_arm_anims.play('BackSlash')
			_curr_attack_dir = AttackDir.Backward
		else:
			_arm_anims.play('ForwardSlash')
			_curr_attack_dir = AttackDir.Forward

		_buffered_state = PlayerState.None
	else:
		if _curr_attack_dir == AttackDir.Forward:
			_arm_anims.play('UnForwardSlash')
		_curr_state = PlayerState.None

func _do_attack():
	var m = get_viewport().get_mouse_position()
	
	raycast.global_position = cam.project_ray_origin(m)
	raycast.target_position = cam.project_local_ray_normal(m) * 100
	raycast.force_raycast_update()

	if raycast.is_colliding():
		launch_projectile(raycast.get_collision_point())

func _dash_anim_complete():
	_curr_state = PlayerState.None