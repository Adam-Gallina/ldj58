extends CharacterBody3D
class_name PlayerController

signal player_dead()

enum PlayerState { None, Dash, Attack, AttackReturn }
enum AttackDir { Forward, Backward }

@onready var cam_pivot : Node3D = $CameraPivot
@onready var cam: Camera3D = $CameraPivot/Camera3D
@onready var model : Node3D = $Model

var _curr_state : PlayerState = PlayerState.None

var _iframe_timer = 0

var _dead = false

@export_category('Movement')
@export var TurnSpeed = 720
@onready var _rad_turn_speed = deg_to_rad(TurnSpeed)
var _disable_movement = false
@export var DashModifier = 1.5
var _dash_dir : Vector3 = Vector3.ZERO


@export_category('Anims')
@onready var _leg_anims : AnimationPlayer = $LegAnimationPlayer
@onready var _arm_anims : AnimationPlayer = $Model/ArmAnimationPlayer
@export var DashEffect : PackedScene
@export var DeathEffect : PackedScene

var _last_coll_radius = -1

func _ready() -> void:
	Constants.set_player(self)
	Constants.set_cam(cam)

func _process(delta):
	if PlayerStats.LegsVisible != $Model/Torso/LegR.visible:
		$Model/Torso/LegR.visible = PlayerStats.LegsVisible
		$Model/Torso/LegL.visible = PlayerStats.LegsVisible

	if _dead: return

	if _iframe_timer > 0: _iframe_timer -= delta

	if _last_coll_radius != PlayerStats.calc_collect_radius():
		_last_coll_radius = PlayerStats.calc_collect_radius()
		$CollectionArea3D/CollisionShape3D.shape.radius = _last_coll_radius

	# Hacky fs
	if _arm_anims.current_animation == '':
		_curr_state = PlayerState.None

	_handle_input(delta)
	var dir = _handle_movement(delta)

	if not _disable_movement:
		if _curr_state == PlayerState.Dash:
			velocity = _dash_dir * PlayerStats.calc_speed() * DashModifier
		else:
			velocity = dir * PlayerStats.calc_speed()
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

			var p = DashEffect.instantiate()
			add_child(p)
			p.global_position = global_position
			p.emitting = true

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
	pass




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


func damage(amount:int):
	if _iframe_timer > 0: return

	PlayerStats._curr_health -= amount

	if PlayerStats._curr_health <= 0:
		death()
	else:
		_iframe_timer = PlayerStats.calc_iframes()

func death():
	_dead = true
	
	_arm_anims.play('dash')
	_leg_anims.play('death')

	var p = DashEffect.instantiate()
	add_child(p)
	p.global_position = global_position
	p.emitting = true

	await _leg_anims.animation_finished

	player_dead.emit()



func _dash_anim_complete():
	_curr_state = PlayerState.None

func _on_collection_area_3d_body_entered(body:Node3D) -> void:
	if body is LootDrop:
		body.collect(self)
