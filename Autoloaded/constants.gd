extends Node

enum ResourceType { None, Rock, Rose, Berry }

@onready var ResourceImg = {
    ResourceType.None: load('res://icon.svg'),
    ResourceType.Berry: load('res://Loot/Resources/berry.png'),
    ResourceType.Rose: load('res://Loot/Resources/Petal.png'),
    ResourceType.Rock: load('res://Loot/Resources/Crystal.png')
}

var ResourceName = {
    ResourceType.None: 'Unknown',
    ResourceType.Berry: 'Belly-Berry',
    ResourceType.Rose: 'Crackle Leaf',
    ResourceType.Rock: 'Rockling Shard'
}

var Player : CharacterBody3D
func set_player(p:CharacterBody3D): Player = p

var Cam : Camera3D
func set_cam(c:Camera3D): Cam = c