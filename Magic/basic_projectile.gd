extends RigidBody3D

@export var Speed = 20
@export var TurnSpeed = 360
@onready var _rad_turn_speed = deg_to_rad(TurnSpeed)
@export var Damage = 1

@export var TrackingEffect : Node3D
@export var EndEffect : Node3D

var _target_pos : Vector3
var _moving = false

func set_target_pos(pos:Vector3):
	pos.y = 0
	_target_pos = pos

func launch(dir:Vector3, target_pos:Vector3):
	linear_velocity = dir.normalized() * Speed
	set_target_pos(target_pos)
	TrackingEffect.emitting = true
	_moving = true


func _process(delta: float) -> void:
	if not _moving: return

	var p = global_position
	p.y = 0
	var ang = linear_velocity.signed_angle_to(_target_pos - p, Vector3.UP)

	if abs(ang) > _rad_turn_speed * delta:
		ang = sign(ang) * _rad_turn_speed * delta
	
	linear_velocity = linear_velocity.rotated(Vector3.UP, ang)

	#model.rotation.y += ang

	if p.distance_to(_target_pos) <= linear_velocity.length() * delta:
		explode()


func explode():
	_moving = false
	linear_velocity = Vector3.ZERO
	
	EndEffect.emitting = true
	TrackingEffect.emitting = false
	$MeshInstance3D.hide()

	var s : ShapeCast3D = $ShapeCast3D

	s.force_shapecast_update()
	for e in range(s.get_collision_count()):
		if s.get_collider(e) is EnemyBase:
			s.get_collider(e).damage(Damage)


func _on_explosion_finished() -> void:
	queue_free()


func _on_body_entered(body) -> void:
	if body is EnemyBase:
		explode()
