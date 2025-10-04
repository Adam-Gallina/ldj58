extends Node

var Damage = .5
func calc_damage() -> float:
	return Damage

var AttackSpeed = 2.
func calc_attack_speed() -> float:
	return 1 / AttackSpeed

var Speed = 10.
func calc_speed() -> float:
	return Speed

var CollectRadius = 4.0
func calc_collect_radius() -> float:
	return CollectRadius


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
