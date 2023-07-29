extends Node2D

class_name Planet

onready var sprite = get_node("Sprite")
export var radius: float = 100
var timer = 0.0 
var m_currentAngle = 0 

onready var circumference = 2 * PI * radius
onready var potionScene  = preload("res://scenes/gameplay/Potion.tscn")
onready var halfPlayerScene = preload("res://scenes/gameplay/HalfPlayer.tscn")

func distanceBetweenAngles(a1, a2):
	return Ranges.circShortestDist(a1, a2) / (2 * PI) * circumference

func angleToArc(a, height_offset = 0):
	return a / (2 * PI) * getCircumference(height_offset)
	
func arcToAngle(a, height_offset = 0):
	return (a / getCircumference(height_offset)) * 2 * PI
	
func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	rotation_degrees = rad2deg(m_currentAngle)
	
#	spawnPotions(delta)

func getCircumference(height_offset = 0):
	return 2 * PI * (radius + height_offset)

func spawnPotions(delta: float):
	timer += delta
	if timer >= 1:
		addPotion()
	
	if Globals.getSingle("player").spawnHalfPlayer:
		if get_tree().get_nodes_in_group("halfPlayer").size() < 1:
			spawnHalfPlayer()
		
func spawnHalfPlayer():
	var halfPlayer = halfPlayerScene.instance()
	if halfPlayer.global_transform.origin.x > Globals.getSingle("player").global_transform.origin.x:
		halfPlayer.scale.x = -1
	add_child(halfPlayer)
	

func addPotion():
	var potion = potionScene.instance()
	potion.m_currentAngle = rand_range(0, 2 * PI)
	add_child(potion)
	timer = 0.0 
