extends Node


func _ready() -> void:
	randomize()

func getSingle(name):
	var ret = get_tree().get_nodes_in_group(name)
#	assert(ret.size() != 0)
	if ret.size():
		return ret[0]
	return null

enum COLLISION_LAYERS {
	WORLD = 1,
	PLAYER = 2,
	ENEMY = 4,
	PUSH = 8
}
