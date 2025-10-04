extends Node3D

func _process(delta: float) -> void:
    if Input.is_key_pressed(KEY_SHIFT) and Input.is_key_pressed(KEY_ESCAPE):
        get_tree().quit()