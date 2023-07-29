extends Node2D

class_name Planet

onready var sprite = get_node("Sprite")
export var radius: float = 100
var spawn_timer = Timer.new()
onready var potionScene  = preload("res://scenes/gameplay/Potion.tscn")
var timer = 0.0  

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	spawnPotions(delta)
	
func spawnPotions(delta: float):
	var potion = potionScene.instance()
	timer += delta
	if timer >= 3:
		potion.startPos = Vector2.ZERO + Vector2(0, -1.5*radius)
		add_child(potion)
		timer = 0.0 
	
