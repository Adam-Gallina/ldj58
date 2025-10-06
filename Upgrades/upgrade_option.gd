extends CharacterBody3D

signal selected(option)

@export var CommonParticles : CPUParticles3D
@export var UncommonParticles : CPUParticles3D
@export var RareParticles : CPUParticles3D

func _process(_delta: float) -> void:
	if not visible: return

	var p = Constants.Player.get_mouse_ray()
	if p != Vector3.ZERO:
		$Label3D.visible = global_position.distance_to(p) < 3

func set_upgrade(upgrade:UpgradeBase):
	$Label3D.hide()
	if upgrade == null:
		hide()
		$CollisionShape3D.set_deferred('disabled', true)
	else:
		show()

		while upgrade.UpgradeChance > 0:
			if randf() < upgrade.UpgradeChance:
				upgrade = upgrade.get_child(0)
			else:
				break


		$CollisionShape3D.set_deferred('disabled', false)
		$Label3D.text = upgrade.UpgradeName + '\n' + upgrade.UpgradeDescription

		if upgrade.UpgradeRarity == UpgradeBase.Rarity.Common:
			CommonParticles.show()
			UncommonParticles.hide()
			RareParticles.hide()
		elif upgrade.UpgradeRarity == UpgradeBase.Rarity.Uncommon:
			CommonParticles.hide()
			UncommonParticles.show()
			RareParticles.hide()
		elif upgrade.UpgradeRarity == UpgradeBase.Rarity.Rare:
			CommonParticles.hide()
			UncommonParticles.hide()
			RareParticles.show()

func damage(_amount):
	selected.emit(self)
