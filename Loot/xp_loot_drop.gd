extends LootDrop
class_name XpDrop

@export var XpValue = 1

@export var OscillateSpeed = 1.
@export var OscillateScaleOffset = .25
@export var MinScale = 1.
@onready var _t = randf() * OscillateSpeed

func _on_gather():
    PlayerStats.collect_xp(self)


func _process(delta: float) -> void:
    super(delta)
    
    _t += delta

    var s = MinScale + sin(_t * PI / OscillateSpeed) * OscillateScaleOffset
    $MeshInstance3D.scale = Vector3(s, s, s)