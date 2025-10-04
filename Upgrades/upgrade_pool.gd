extends Node

var _upgrades : Array[UpgradeBase] = []
var _upgrade_total = 0

func _ready() -> void:
	for c in get_children():
		if c is UpgradeBase:
			_upgrades.append(c)
			_upgrade_total += c.Chance

func select_upgrades(amount:int=3, allow_dupes=false) -> Array[UpgradeBase]:
	var selected : Array[UpgradeBase] = []

	while selected.size() < amount:
		var r = randi() % _upgrade_total
		
		for u in _upgrades:
			r -= u.Chance
			if r <= 0:
				if selected.find(u) != -1 and not allow_dupes:
					break
				selected.append(u)
				break

	return selected
