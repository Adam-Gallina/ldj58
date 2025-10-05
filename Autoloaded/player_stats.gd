extends Node

var Level = 0

var Health = 3
@onready var _curr_health = Health
func change_max_health(amount:int):
	if amount > 0:
		_curr_health += amount
		Health += amount
	else:
		Health += amount
		if Health < _curr_health:
			_curr_health = Health

var Damage = .5
func calc_damage() -> float:
	if Damage < 0: Damage = .1
	return Damage

var AttackSpeed = 1.
func calc_attack_speed() -> float:
	if AttackSpeed < 0: AttackSpeed = .1
	return 1 / AttackSpeed

var Speed = 10.
func calc_speed() -> float:
	return Speed

var CollectRadius = 4.0
func calc_collect_radius() -> float:
	return CollectRadius


var CastAmount = 1

var CastRadius = .35

var CastPierce = 0


var _stored_xp : Array[XpDrop] = []

func collect_xp(xp:XpDrop):
	_stored_xp.append(xp)
	xp.get_parent().remove_child(xp)

func deposit_xp(amount_needed):
	var s = []

	while amount_needed > 0 and _stored_xp.size() > 0:
		amount_needed -= _stored_xp[0].XpValue
		s.append(_stored_xp.pop_front())

	return s


## { Constants.ResourceType : Array[LootDrop] }
var _stored_resources : Dictionary = {}
var CurrResource : Constants.ResourceType

func collect_resource(resource:ResourceDrop):
	if not _stored_resources.get(resource.ResourceType):
		_stored_resources[resource.ResourceType] = [resource]
	else:
		_stored_resources[resource.ResourceType].append(resource)

	resource.get_parent().remove_child(resource)

func deposit_resource(resource_type:Constants.ResourceType, amount_needed:int):
	var s = []

	if not _stored_resources.get(resource_type):
		return s

	while amount_needed > 0 and _stored_resources[resource_type].size() > 0:
		amount_needed -= 1
		s.append(_stored_resources[resource_type].pop_front())

	return s
