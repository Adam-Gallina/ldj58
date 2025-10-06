extends Node3D

@export var ActiveHeight = 0.
@export var InactiveHeight = -7.2

@export var MinPlayerDist = 6
@export var MaxPlayerDist = 8
@export var MinVineOffsetDist = 5

@export var Segments : Array[Node3D]

func _process(_delta: float) -> void:
    var dist = global_position.distance_to(Constants.Player.global_position)
    if dist < MaxPlayerDist:
        PlayerStats.PlayerSafe = true

        var t = (dist - MinPlayerDist) / (MaxPlayerDist - MinPlayerDist)
        if t < 0: t = 0

        for s in Segments:
            #var vpos = s.global_position
            #vpos.y = 0 
            #var vdist = vpos.distance_to(Constants.Player.global_position)
            #var vt = vdist / MinVineOffsetDist
            s.position.y = ActiveHeight + (InactiveHeight - ActiveHeight) * t
    else:
        PlayerStats.PlayerSafe = false
    