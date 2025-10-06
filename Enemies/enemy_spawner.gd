extends Node

@export var EnemyScene : PackedScene
@export var EnemyGroup = 'Enemy'

@export var spawning = true
@export var MinSpawnLevel = 1

@export var StartSpawnRate = .25
@export var LevelIncreaseRate = .125
@onready var _next_spawn = StartSpawnRate

@export var StartEnemyHealth = 10
@export var LevelIncreaseHealth = 3

@export var StartMaxEnemyCount = 5
@export var LevelIncreaseMaxCount = 3

@export var SpawnGraceDist = 10
@export var SpawnMaxDist = 40

func _process(delta: float) -> void:
	if not spawning: return
	if PlayerStats.Level < MinSpawnLevel: return

	_next_spawn -= delta
	if _next_spawn <= 0:
		_next_spawn = 1 / (StartSpawnRate + LevelIncreaseRate * PlayerStats.Level)
		_spawn_enemy()


func _spawn_enemy():
	if get_tree().get_nodes_in_group(EnemyGroup).size() >= StartMaxEnemyCount + LevelIncreaseMaxCount * PlayerStats.Level:
		return

	var e = EnemyScene.instantiate()
	add_child(e)
	
	var p = _get_spawn_pos()
	p = NavigationServer3D.map_get_closest_point(e._nav_agent.get_navigation_map(), p) - Vector3.UP * e._nav_agent.path_height_offset
	e.global_position = p

	e.set_health(StartEnemyHealth + LevelIncreaseHealth * PlayerStats.Level)
	

func _get_spawn_pos() -> Vector3:
	var pos = Vector3.RIGHT * randi_range(SpawnGraceDist, SpawnMaxDist)
	pos = pos.rotated(Vector3.UP, randf() * 2 * PI)

	return pos + Constants.Player.global_position
