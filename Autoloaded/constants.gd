extends Node

enum ResourceType { None, Rock, Rose, Berry }

@onready var ResourceImg = {
    ResourceType.None: load('res://icon.svg'),
    ResourceType.Berry: load('res://Loot/Resources/berry.png')
}

var ResourceName = {
    ResourceType.None: 'Unknown',
    ResourceType.Berry: 'Belly-Berry'
}

var Player : CharacterBody3D
func set_player(p:CharacterBody3D): Player = p

var Cam : Camera3D
func set_cam(c:Camera3D): Cam = c