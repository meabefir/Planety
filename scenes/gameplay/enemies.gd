extends Node2D

onready var m_enemyScene = preload("res://scenes/gameplay/enemy.tscn")

func _ready():
#	return
	for i in range (0, 3):
		spawnEnemy()
	
func spawnEnemy():
	var enemy = m_enemyScene.instance()
	enemy.m_currentAngle = rand_range(0, 2 * PI)
	add_child(enemy)
	enemy.m_planet = get_parent()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("test"):
		pass
