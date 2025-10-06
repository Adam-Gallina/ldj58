extends StaticBody3D

@export_category('Loot')
@export var LootSpawnAng = 90
@export var LootSpawnForce = 20
@export var ResourceDropScene : PackedScene
@export var ResourceDropType : Constants.ResourceType

@export var ResourceSprites : Array[Node3D]
@onready var _remaining_resource = ResourceSprites.size()

func damage(_amount):
	if _remaining_resource <= 0: return
	if PlayerStats.CurrResource != ResourceDropType: return

	_remaining_resource -= 1
	ResourceSprites[_remaining_resource].hide()

	var l = ResourceDropScene.instantiate()
	get_parent().add_child(l)
	l.global_position = global_position + Vector3.UP
	l.launch(LootSpawnAng, LootSpawnForce)
