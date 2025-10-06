extends EnemyBase

@export var ChargeSpeed = 10

func _process(delta: float) -> void:
	super(delta)

	if PlayerStats.LegsVisible != $Model/Body/LegL1.visible:
		$Model/Body/LegL1.visible = PlayerStats.LegsVisible
		$Model/Body/LegL2.visible = PlayerStats.LegsVisible
		$Model/Body/LegL3.visible = PlayerStats.LegsVisible
		$Model/Body/LegR1.visible = PlayerStats.LegsVisible
		$Model/Body/LegR2.visible = PlayerStats.LegsVisible
		$Model/Body/LegR3.visible = PlayerStats.LegsVisible


func do_attack():
	_keep_anim('Attack')
	_curr_state = EnemyState.Attacking

	await _anim.animation_finished

	_keep_anim('Charge')
	_curr_state = EnemyState.Charging
	attack_timer.start()

	var target_dir = global_position.direction_to(Constants.Player.global_position)
	velocity = target_dir * ChargeSpeed


	
func _on_attack_timer_timeout() -> void:
	velocity = Vector3.ZERO
	await get_tree().create_timer(.5).timeout
	_keep_anim('Walk')
	_curr_state = EnemyState.Following
	_attack_cooldown = AttackCooldown


func _on_area_3d_body_entered(body:Node3D) -> void:
	print(body)
	if _curr_state != EnemyState.Charging: return

	body.damage(Damge)
