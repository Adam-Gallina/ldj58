extends RigidBody3D
class_name BasicProjectile

@export var Speed = 20
@export var Damage = 1

@export var Pierce : int = 0
@onready var _remaining_pierce = Pierce
func set_pierce(amount):
	_remaining_pierce += amount - Pierce
	Pierce = amount

@export var TrackingEffect : Node3D
@export var EndEffect : Node3D

var _target_pos : Vector3
var _moving = false
var _sploded = false

@onready var _hit_audio : AudioStreamPlayer3D = get_node_or_null('AudioStreamPlayer3D')

func set_radius(amount):
	$ShapeCast3D.shape.radius = amount

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

	if global_position.distance_to(_target_pos) <= linear_velocity.length() * delta:
		explode()


func explode():
	if _sploded: return

	_sploded = true
	_moving = false
	linear_velocity = Vector3.ZERO
	
	EndEffect.emitting = true
	TrackingEffect.emitting = false
	$MeshInstance3D.hide()
	if _hit_audio != null:
		_hit_audio.play()

	var s : ShapeCast3D = $ShapeCast3D

	s.force_shapecast_update()

	for e in range(s.get_collision_count()):
		if s.get_collider(e):
			s.get_collider(e).damage(Damage)


func _on_explosion_finished() -> void:
	queue_free()


func _on_body_entered(body) -> void:
	if not _moving: return

	_remaining_pierce -= 1
	if body is EnemyBase:
		body.damage(Damage)

	if body.is_in_group('Environment') or _remaining_pierce < 0:
		explode()
	
