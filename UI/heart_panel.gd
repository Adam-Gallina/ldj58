extends Control

@export var FullHeart : Texture
@export var BrokenHeart : Texture
@export var BrokenColor = Color(.3, .3, .3)

@export var PumpSpeed = .25
@export var PumpScale = .4
@export var PumpDelay = .25
@onready var _pump_target = $Control
var _pumping = false
@onready var _p = PumpSpeed
func set_pumping(pump:bool): _pumping = pump

@onready var texture : TextureRect = $Control/TextureRect
var _broken = false
func set_broken(broke:bool):
    texture.texture = BrokenHeart if broke else FullHeart
    texture.self_modulate = BrokenColor if broke else Color.WHITE
    _broken = broke


func _process(delta: float) -> void:
    if _pumping and not _broken:
        _p -= delta
        if _p <= -PumpDelay:
            _p = PumpSpeed
        elif _p > 0:
            var t = _p / (PumpSpeed / 2.)

            if t > 1: t = 2 - t
            var s = 1 + PumpScale * t
            _pump_target.scale = Vector2(s, s)
    else:
        _pump_target.scale = Vector2(1, 1)
