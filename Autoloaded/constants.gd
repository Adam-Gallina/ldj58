extends Node

enum ResourceType { None, Rock, Rose, Berry, Bark, Mushroom, Mandible, Wing, Shell }

@onready var ResourceImg = {
    ResourceType.None: load('res://icon.svg'),
    ResourceType.Berry: load('res://Loot/Resources/berry.png'),
    ResourceType.Rose: load('res://Loot/Resources/Petal.png'),
    ResourceType.Rock: load('res://Loot/Resources/Crystal.png'),
    ResourceType.Bark: load('res://Loot/Resources/bark.png'),
    ResourceType.Mushroom: load('res://Loot/Resources/Mushroom.png'),
    ResourceType.Mandible: load('res://Loot/Resources/Mandible.png'),
    ResourceType.Wing: load('res://Loot/Resources/Lacewing.png'),
    ResourceType.Shell: load('res://Loot/Resources/Shell.png')
}

var ResourceName = {
    ResourceType.None: 'Unknown',
    ResourceType.Berry: 'Belly-Berry',
    ResourceType.Rose: 'Crackle Leaf',
    ResourceType.Rock: 'Rockling Shard',
    ResourceType.Bark: 'Autumn Bark',
    ResourceType.Mushroom: 'Flatshroom',
    ResourceType.Mandible: 'Jawbeetle Mandible',
    ResourceType.Wing: 'Lacewing',
    ResourceType.Shell: 'Speedshell'
}

var Player : CharacterBody3D
func set_player(p:CharacterBody3D): Player = p

var Cam : Camera3D
func set_cam(c:Camera3D): Cam = c