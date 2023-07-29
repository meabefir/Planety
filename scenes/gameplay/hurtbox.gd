extends Area2D

class_name Hurtbox

signal hurt(data)

func hurt(data = {}):
	emit_signal("hurt", data)
