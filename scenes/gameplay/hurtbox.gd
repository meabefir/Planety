extends Area2D

class_name Hurtbox

signal collision(data)

func collision(data = {}):
	emit_signal("collision", data)
