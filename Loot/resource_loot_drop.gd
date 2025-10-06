extends LootDrop
class_name ResourceDrop

@export var ResourceType : Constants.ResourceType

func _on_gather():
    PlayerStats.collect_resource(self)
    $Particles.emitting = false