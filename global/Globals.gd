extends Node


func getSingle(name):
	var ret = get_tree().get_nodes_in_group(name)
	assert(ret.size() != 0)
	return ret[0]

func planet():
	var planet = get_tree().get_nodes_in_group("planet")
	assert(planet.size() != 0)
	return planet[0]

func projectiles():
	pass
