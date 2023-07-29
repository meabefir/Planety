extends Node


func _ready() -> void:
	randomize()

func getSingle(name):
	var ret = get_tree().get_nodes_in_group(name)
	assert(ret.size() != 0)
	return ret[0]
