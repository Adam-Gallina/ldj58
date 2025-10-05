extends StaticBody3D

var _player_in_range = false

@export var UpgradePool : Node
@export var WeaponUpgradePool : Node
var _curr_upgrades : Array[UpgradeBase] = []

@export var UpgradeStartXp = 10
@export var UpgradeStepXp = 10
@onready var _curr_upgrade_xp = UpgradeStartXp
@onready var _remaining_upgrade_xp = _curr_upgrade_xp

@export var ResourceTypes : Array[Constants.ResourceType]
@export var ResourceAmounts : Array[int] 
var _curr_resource = 0
var _remaining_resource_amount = 0

@export_group('Anims')
@export var XpAnimSpeed = 10
@export var XpAnimSpacing = .05
@export var MaxXpOffset = .25

func _ready() -> void:
	$UpgradeOption.set_upgrade(null)
	$UpgradeOption2.set_upgrade(null)
	$UpgradeOption3.set_upgrade(null)

	PlayerStats.CurrResource = ResourceTypes[_curr_resource]
	PlayerStats.CurrResourceTarget = ResourceAmounts[_curr_resource]
	_remaining_resource_amount = ResourceAmounts[_curr_resource]


func _collect_resource(xp_count=0):
	$CollectPath3D.curve.set_point_position(0, Constants.Player.global_position + Vector3.UP - global_position)

	var xp = PlayerStats.deposit_resource(ResourceTypes[_curr_resource], _remaining_resource_amount)
	for x in range(xp.size()):
		_remaining_resource_amount -= 1
		_collect_xp_anim(xp[x], x + xp_count)

	if _remaining_resource_amount <= 0:
		choose_weapon_upgrades()
		_curr_resource += 1
		PlayerStats.CurrResource = ResourceTypes[_curr_resource]
		PlayerStats.CurrResourceTarget = ResourceAmounts[_curr_resource]
		_remaining_resource_amount = ResourceAmounts[_curr_resource]

func _collect_xp():
	$CollectPath3D.curve.set_point_position(0, Constants.Player.global_position + Vector3.UP - global_position)

	var xp = PlayerStats.deposit_xp(_remaining_upgrade_xp)
	var xp_count = xp.size()
	for x in range(xp.size()):
		_remaining_upgrade_xp -= xp[x].XpValue
		_collect_xp_anim(xp[x], x)

	if _remaining_upgrade_xp <= 0:
		choose_upgrades()
		_curr_upgrade_xp += UpgradeStepXp
		_remaining_upgrade_xp += _curr_upgrade_xp
	else:
		_collect_resource(xp_count)

func _collect_xp_anim(xp, delay):
	if delay != 0:
		await get_tree().create_timer(XpAnimSpacing * delay).timeout

	var p : PathFollow3D = $CollectPath3D/PathFollow3D.duplicate()
	$CollectPath3D.add_child(p)
	p.add_child(xp)
	xp.position = Vector3(randf_range(-MaxXpOffset, MaxXpOffset), 0, randf_range(-MaxXpOffset, MaxXpOffset))

	while p.progress_ratio < 1:
		p.progress += XpAnimSpeed * get_process_delta_time()
		await get_tree().process_frame

	xp.queue_free()
	

func choose_upgrades():
	_curr_upgrades = UpgradePool.select_upgrades(3)
	$UpgradeOption.set_upgrade(_curr_upgrades[0])
	$UpgradeOption2.set_upgrade(_curr_upgrades[1])
	$UpgradeOption3.set_upgrade(_curr_upgrades[2])

func choose_weapon_upgrades():
	_curr_upgrades = WeaponUpgradePool.select_upgrades(2)
	$UpgradeOption.set_upgrade(_curr_upgrades[0])
	$UpgradeOption2.set_upgrade(_curr_upgrades[1])


func _on_area_3d_body_entered(body:Node3D) -> void:
	if body.name == "Player":
		_player_in_range = true
		if _curr_upgrades.size() == 0:
			_collect_xp()


func _on_area_3d_body_exited(body:Node3D) -> void:
	if body.name == "Player":
		_player_in_range = false


func _option_selected(_option, num):
	$UpgradeOption.set_upgrade(null)
	$UpgradeOption2.set_upgrade(null)
	$UpgradeOption3.set_upgrade(null)

	_curr_upgrades[num].apply_upgrade()
	_curr_upgrades = []

	PlayerStats.Level += 1
	GameStats.Upgrades += 1

	if _player_in_range: 
		_collect_xp()
		if _curr_upgrades.size() == 0:
			_collect_resource()
