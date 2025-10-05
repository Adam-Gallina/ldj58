extends CharacterBody3D

signal selected(option)

func set_upgrade(upgrade:UpgradeBase):
	if upgrade == null:
		hide()
		$CollisionShape3D.set_deferred('disabled', true)
	else:
		show()
		$CollisionShape3D.set_deferred('disabled', false)
		$Label3D.text = upgrade.UpgradeName + '\n' + upgrade.UpgradeDescription

func damage(_amount):
	selected.emit(self)
