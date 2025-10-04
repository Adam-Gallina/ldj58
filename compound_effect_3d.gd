extends Node3D

signal finished

@export var emitting = false

func _ready() -> void:
    for i in get_children():
        if i is CPUParticles3D:
            i.finished.connect(finished.emit)
            break

func _process(_delta: float) -> void:
    for i in get_children():
        if i is CPUParticles3D:
            i.emitting = emitting

