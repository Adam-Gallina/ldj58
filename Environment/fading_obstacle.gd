extends StaticBody3D

@export var TargetFade : MeshInstance3D
@export var MaxFade : float = 0.
@export var FadeStartDist : float = 3.5
@export var MaxFadeDist : float = 1.


func _process(_delta: float) -> void:
	if Constants.Player.global_position.z > global_position.z:
		TargetFade.material_override.albedo_color.a = 1
		return

	var xstop = abs(Constants.Player.global_position.x - global_position.x)

	var xt = 0
	if xstop > FadeStartDist:
		xt = 1.
	elif xstop > MaxFadeDist:
		xt = (xstop - MaxFadeDist) / (FadeStartDist - MaxFadeDist)

	TargetFade.material_override.albedo_color.a = MaxFade + (1 - MaxFade) * xt
