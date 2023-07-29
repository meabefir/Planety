extends Node2D

class_name Planet

onready var sprite = get_node("Sprite")
export var radius: float = 100
<<<<<<< HEAD

=======
onready var circumference = 2 * PI * radius

func distanceBetweenAngles(a1, a2):
	return Ranges.circShortestDist(a1, a2) / (2 * PI) * circumference

func arcLength(a):
	return a / (2 * PI) * circumference
var spawn_timer = Timer.new()
>>>>>>> 71e936ff6d6fbb5a85c69c2c44f6da5fefaa4904
onready var potionScene  = preload("res://scenes/gameplay/Potion.tscn")
var timer = 0.0  

func _ready() -> void:
	var potion = potionScene.instance()
	potion.startPos = Vector2.ZERO + Vector2(0, -1.5*radius)
	add_child(potion)
	
func _process(delta: float) -> void:
	#spawnPotions(delta)
	
	pass

func spawnPotions(delta: float):
	var potion = potionScene.instance()
	timer += delta
	if timer >= 3:
		potion.startPos = Vector2.ZERO + Vector2(0, -1.5*radius)
		add_child(potion)
		timer = 0.0 