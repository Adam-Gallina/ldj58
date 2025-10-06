extends Node
class_name UpgradeBase

enum Rarity { Common, Uncommon, Rare }

@export var UpgradeName = "Unnamed Upgrade"
@export var UpgradeDescription = "does something"
@export var UpgradeRarity : Rarity

@export var HealthMod = 0
@export var DamageMod = 0.
@export var AttackSpeedMod = 0.
@export var SpeedMod = 0.
@export var CollectRadiusMod = 0.

@export_group("Weapon mods")
@export var CastAmountMod = 0
@export var CastRadiusMod = 0.
@export var CastPierceMod = 0

@export var Chance = 10

func apply_upgrade():
    if HealthMod != 0:
        PlayerStats.change_max_health(HealthMod)

    PlayerStats.Damage += DamageMod
    PlayerStats.AttackSpeed += AttackSpeedMod
    PlayerStats.Speed += SpeedMod
    PlayerStats.CollectRadius += CollectRadiusMod

    PlayerStats.CastAmount += CastAmountMod
    PlayerStats.CastRadius += CastRadiusMod
    PlayerStats.CastPierce += CastPierceMod
