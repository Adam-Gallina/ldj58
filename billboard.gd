@tool
extends Node3D

@export var lock_x = true
@export var disable_in_editor = false

func _process(_delta):
	if Engine.is_editor_hint():
		if not disable_in_editor:
			var editor_interface = Engine.get_singleton("EditorInterface")
			var c = editor_interface.get_editor_viewport_3d(0).get_camera_3d()
			global_rotation.y = c.rotation.y
			if !lock_x: global_rotation.x = c.rotation.x
		else:
			rotation.y = 0
			rotation.x = 0
	#elif Constants.GameCam != null:
	#	global_rotation.y = Constants.GameCam.yaw
	#	if !lock_x: global_rotation.x = Constants.GameCam.pitch
	else:
		global_rotation.y = get_viewport().get_camera_3d().rotation.y
		#if !lock_x:
		#	global_rotation.x = get_viewport().get_camera_3d().get_node('$Pivot').rotation.x
