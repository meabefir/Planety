extends Node2D

class_name Planet

onready var sprite = get_node("Sprite")
export var radius: float = 100
onready var circumference = 2 * PI * radius

func distanceBetweenAngles(a1, a2):
	return Ranges.circShortestDist(a1, a2) / (2 * PI) * circumference

func arcLength(a):
	return a / (2 * PI) * circumference
