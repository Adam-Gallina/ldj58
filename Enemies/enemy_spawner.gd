extends Node

@export var EnemyScenes : Array[PackedScene]

@export var spawning = true

@export var SpawnLevelIncreaseRate = 20
var _spawn_level = 1
@onready var _next_increase = SpawnLevelIncreaseRate


@export var StartSpawnRate = .25
@export var LevelIncreaseRate = .125
@onready var _next_spawn = StartSpawnRate

@export var StartEnemyHealth = 2
@export var LevelIncreaseHealth = 2


@export var SpawnGraceDist = 10
@export var SpawnMaxDist = 40

func _process(delta: float) -> void:
	if not spawning: return

	_next_increase -= delta
	if _next_increase <= 0:
		_next_increase = SpawnLevelIncreaseRate
		_spawn_level += 1

	_next_spawn -= delta
	if _next_spawn <= 0:
		_next_spawn = 1 / (StartSpawnRate + LevelIncreaseRate * _spawn_level)
		_spawn_enemy()


func _spawn_enemy():
	var e = EnemyScenes[0].instantiate()
	add_child(e)
	
	var p = _get_spawn_pos()
	p = NavigationServer3D.map_get_closest_point(e._nav_agent.get_navigation_map(), p) - Vector3.UP * e._nav_agent.path_height_offset
	e.global_position = p

	e.set_health(StartEnemyHealth + LevelIncreaseHealth * _spawn_level)
	

func _get_spawn_pos() -> Vector3:
	var pos = Vector3.RIGHT * randi_range(SpawnGraceDist, SpawnMaxDist)
	pos = pos.rotated(Vector3.UP, randf() * 2 * PI)

	return pos + Constants.Player.global_position
