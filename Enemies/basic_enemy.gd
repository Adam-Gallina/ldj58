extends CharacterBody3D
class_name EnemyBase

enum EnemyState { None, Following, Attacking, Dying }

@export_category('Health')
@export var MaxHealth = 2
@onready var _curr_health : float = MaxHealth

func set_health(max_health):
	_curr_health += max_health - MaxHealth
	MaxHealth = max_health

@export_category('Combat')
@export var Damge = 1
@export var AttackRange = 3
@export var AttackProjectile : PackedScene

@onready var attack_timer : Timer = $AttackTimer

@export_category('Movement')
@export var WanderSpeed = 3
@export var Speed = 6
@export var TurnSpeed = 360
@onready var _rad_turn_speed = deg_to_rad(TurnSpeed)
@export var DetectionRange = 10
@export var FollowingDetectionRange = 20
@export var WanderRange = 5
@onready var _nav_agent : NavigationAgent3D = $NavigationAgent3D

var _curr_state : EnemyState = EnemyState.None

@export_category('Loot')
@export var LootSpawnAng = 90
@export var LootSpawnForce = 20
@export var PossibleLoot : Array[PackedScene]
## Chance out of 1.
@export var LootChance : Array[float]


@onready var model = $Model
@onready var _anim = $Model/AnimationPlayer

func _ready():
	_nav_agent.velocity_computed.connect(_on_velocity_calculated)
	_nav_agent.navigation_finished.connect(_on_navigation_finished)
	_nav_agent.set_target_position(get_random_pos())
	_nav_agent.max_speed = WanderSpeed
	_keep_anim('Walk')

func _process(_delta: float) -> void:
	if _curr_state == EnemyState.Dying: return

	if velocity != Vector3.ZERO:
		var ang = model.basis.z.signed_angle_to(velocity, Vector3.UP)

		if abs(ang) > _rad_turn_speed * get_process_delta_time():
			ang = sign(ang) * _rad_turn_speed * get_process_delta_time()
		
		model.rotation.y += ang

	if Constants.Player == null: return
	var dist = global_position.distance_to(Constants.Player.global_position)

	if _curr_state == EnemyState.None:
		if dist <= DetectionRange:
			_curr_state = EnemyState.Following
			_nav_agent.max_speed = Speed

	elif _curr_state == EnemyState.Following:
		if dist <= AttackRange:
			do_attack()
		elif dist > FollowingDetectionRange:
			_curr_state = EnemyState.None
			_nav_agent.max_speed = WanderSpeed

func _physics_process(_delta: float) -> void:
	if _curr_state == EnemyState.Dying: 
		return
	elif _curr_state == EnemyState.Following:
		_nav_agent.set_target_position(Constants.Player.global_position)

	var next_pos : Vector3 = _nav_agent.get_next_path_position()
	var next_v : Vector3 = global_position.direction_to(next_pos) * _nav_agent.max_speed
	if _nav_agent.avoidance_enabled:
		_nav_agent.set_velocity(next_v)
	else:
		_on_velocity_calculated(next_v)

func _on_velocity_calculated(safe_v : Vector3):
	if _curr_state == EnemyState.Dying: return
	elif _curr_state == EnemyState.Attacking: return
	velocity = safe_v
	move_and_slide()

func _on_navigation_finished():
	if _curr_state == EnemyState.None:
		_nav_agent.set_target_position(get_random_pos())

func get_random_pos():
	var dir = Vector3.FORWARD.rotated(Vector3.UP, randf() * 2 * PI)
	dir *= WanderRange * randf()
	return global_position + dir


func do_attack():
	_keep_anim('Attack')
	_curr_state = EnemyState.Attacking
	attack_timer.start()

	await _anim.animation_finished

	_keep_anim('Walk')
	_curr_state = EnemyState.Following
	attack_timer.stop()

func _on_attack_timer_timeout() -> void:
	var dir = model.basis.z.rotated(Vector3.UP, deg_to_rad(-10 + randf() * 20))

	var p = AttackProjectile.instantiate()
	get_parent().add_child(p)
	p.global_position = global_position + Vector3.UP

	p.launch(dir, dir * 10)


func _keep_anim(anim_name):
	if _anim.current_animation == anim_name: return
	_anim.play(anim_name)



func damage(amount):
	if _curr_state == EnemyState.Dying: return

	_curr_health -= amount
	if _curr_state == EnemyState.None:
		_curr_state = EnemyState.Following

	if _curr_health <= 0:
		death()

func death():
	_curr_state = EnemyState.Dying

	for i in range(PossibleLoot.size()):
		if LootChance[i] == 1. or randf() < LootChance[i]:
			var l = PossibleLoot[i].instantiate()
			get_parent().add_child(l)
			l.global_position = global_position
			l.launch(LootSpawnAng, LootSpawnForce)

	queue_free()
