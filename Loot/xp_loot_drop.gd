extends LootDrop
class_name XpDrop

@export var XpValue = 1

func _on_gather():
    PlayerStats.collect_xp(self)
