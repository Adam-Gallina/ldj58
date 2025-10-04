extends Node
class_name UpgradeBase

@export var UpgradeName = "Unnamed Upgrade"
@export var UpgradeDescription = "does something"
@export var DamageMod = 0.
@export var AttackSpeedMod = 0.
@export var SpeedMod = 0.
@export var CollectRadiusMod = 0.

@export var Chance = 10

func apply_upgrade():
    PlayerStats.Damage += DamageMod
    PlayerStats.AttackSpeed += AttackSpeedMod
    PlayerStats.Speed += SpeedMod
    PlayerStats.CollectRadius += CollectRadiusMod
