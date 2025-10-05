extends Node

enum ResourceType { None, Rock, Rose }

var Player : CharacterBody3D
func set_player(p:CharacterBody3D): Player = p

var Cam : Camera3D
func set_cam(c:Camera3D): Cam = c