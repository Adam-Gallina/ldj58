extends BasicProjectile

@export var TurnSpeed = 360
@onready var _rad_turn_speed = deg_to_rad(TurnSpeed)
@export var StopAtTarget = false


func _process(delta: float) -> void:
	if not _moving: return

	var p = global_position
	p.y = 0
	var ang = linear_velocity.signed_angle_to(_target_pos - p, Vector3.UP)

	if abs(ang) > _rad_turn_speed * delta:
		ang = sign(ang) * _rad_turn_speed * delta
	
	linear_velocity = linear_velocity.rotated(Vector3.UP, ang)

	#model.rotation.y += ang

	if StopAtTarget and p.distance_to(_target_pos) <= linear_velocity.length() * delta:
		explode()