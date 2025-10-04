extends CharacterBody3D
class_name EnemyBase

@export var MaxHealth = 2
@onready var _curr_health : float = MaxHealth
var _dead = false

func damage(amount):
    if _dead: return

    _curr_health -= amount

    if _curr_health <= 0:
        death()

func death():
    _dead = true
    queue_free()