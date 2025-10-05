extends PlayerController

@export_category('Combat')
@export var ProjectileScene : PackedScene
@onready var raycast : RayCast3D = $CameraPivot/Camera3D/RayCast3D
var _curr_attack_dir = AttackDir.Forward
var _attacking = false
var _next_attack : float

func _handle_input(delta):
	super(delta)

	if Input.is_action_just_pressed('Fire'):
		_attacking = true
	elif Input.is_action_just_released('Fire'):
		_attacking = false
		
	if _next_attack > 0: _next_attack -= delta
	if _attacking and _next_attack <= 0:
		if _curr_state == PlayerState.None:
			_keep_arm_anim('ForwardSlash')
			_curr_state = PlayerState.Attack
		_do_attack()
		_next_attack = PlayerStats.calc_attack_speed()




func launch_projectile(target_pos:Vector3, delay=0):
	if delay > 0:
		await get_tree().create_timer(delay * .15).timeout
		target_pos += (Vector3.RIGHT * randf() * .5).rotated(Vector3.UP, randf() * 2 * PI)

	var p = ProjectileScene.instantiate()
	p.Damage = PlayerStats.calc_damage()
	get_parent().add_child(p)
	p.set_pierce(PlayerStats.CastPierce)
	p.set_radius(PlayerStats.CastRadius)
	p.global_position = global_position + Vector3.UP


	#p.launch(model.basis.z, target_pos)
	p.launch(target_pos - global_position, target_pos)

	
func _attack_anim_complete():
	if _attacking:
		if _curr_attack_dir == AttackDir.Forward:
			_arm_anims.play('BackSlash')
			_curr_attack_dir = AttackDir.Backward
		else:
			_arm_anims.play('ForwardSlash')
			_curr_attack_dir = AttackDir.Forward
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
		GameStats.SpellsCast += PlayerStats.CastAmount
		for i in range(PlayerStats.CastAmount):
			launch_projectile(raycast.get_collision_point(), i)


func _dash_anim_complete():
	if _attacking:
		_arm_anims.play('ForwardSlash')
		_curr_state = PlayerState.Attack
	else:
		super()
