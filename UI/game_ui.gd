extends CanvasLayer

@onready var HeartContainer = $HBoxContainer
@export var HeartScene : PackedScene
var _hearts = []
var _last_health = -1
var _curr_pumping = null

func _ready() -> void:
	$DeathScreen.hide()

func _process(_delta: float) -> void:
	_update_health()


func _update_health():
	if PlayerStats._curr_health != _last_health or PlayerStats.Health > _hearts.size():
		while PlayerStats.Health > _hearts.size():
			var h = HeartScene.instantiate()
			HeartContainer.add_child(h)
			HeartContainer.move_child(h, 0)
			_hearts.insert(0, h)

		for i in range(_hearts.size()):
			if i < PlayerStats._curr_health:
				_hearts[i].set_broken(false)
				if i == PlayerStats._curr_health - 1:
					if _curr_pumping != null:
						_curr_pumping.set_pumping(false)
					_curr_pumping = _hearts[i]
					_curr_pumping.set_pumping(true)
			else:
				_hearts[i].set_broken(true)
		
		_last_health = PlayerStats._curr_health

		if PlayerStats._curr_health == 0:
			$DeathScreen.show()


func _on_restart_pressed() -> void:
	GameStats.reset()
	PlayerStats.reset()
	get_tree().reload_current_scene()
