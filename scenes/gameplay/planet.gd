extends Node2D

class_name Planet

var spawn_timer = Timer.new()

onready var sprite = get_node("Sprite")
export var radius: float = 100
var timer = 0.0 
var m_currentAngle = 0 

onready var circumference = 2 * PI * radius
onready var potionScene  = preload("res://scenes/gameplay/Potion.tscn")


func distanceBetweenAngles(a1, a2):
	return Ranges.circShortestDist(a1, a2) / (2 * PI) * circumference

func angleToArc(a):
	return a / (2 * PI) * circumference
	
func arcToAngle(a):
	return (a / circumference) * 2 * PI
	
	spawn_timer = Timer.new()

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	rotation_degrees = rad2deg(m_currentAngle)
	
	spawnPotions(delta)

func spawnPotions(delta: float):
	timer += delta
	if timer >= 1:
		addPotion()
		
func addPotion():
	var potion = potionScene.instance()
	potion.m_currentAngle = rand_range(0, 2 * PI)
	add_child(potion)
	timer = 0.0 
