extends RigidBody3D
class_name LootDrop

var _target : Node3D
@export var CollectAccel = 3
var _curr_speed = 0


func launch(ang=90, launch_speed=20, LaunchTowardsPlayer=false):
	var dir

	if LaunchTowardsPlayer:
		dir = global_position.direction_to(Constants.Player.global_position)
		dir.y = 0
		dir = dir.normalized()
		dir = dir.rotated(dir.cross(Vector3.UP).normalized(), PI/8 - deg_to_rad(ang/2.) + randf() * deg_to_rad(ang))
		dir = dir.rotated(Vector3.UP, -deg_to_rad(ang/2.) +  randf() * deg_to_rad(ang))
	else:
		dir = Vector3.UP.rotated(Vector3.RIGHT, randf() * deg_to_rad(ang/2.))
		dir = dir.rotated(Vector3.UP, randf() * 2 * PI)

	linear_velocity = dir * launch_speed

func collect(source:Node3D):
	$CollisionShape3D.set_deferred("disabled", true)
	_target = source


func _process(delta: float) -> void:
	if _target != null:
		_curr_speed += CollectAccel * delta
		linear_velocity = global_position.direction_to(_target.global_position + Vector3.UP) * _curr_speed

		if linear_velocity.length() * delta >= global_position.distance_to(_target.global_position + Vector3.UP):
			_on_gather()
			_target = null
			freeze = true


func _on_gather():
	queue_free()