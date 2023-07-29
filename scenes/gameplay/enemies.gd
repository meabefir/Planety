extends Node2D

onready var m_enemyScene = preload("res://scenes/gameplay/enemy.tscn")
export var health: float = 50

func _ready():
	for i in range (0, 5):
		spawnEnemy()
	
func spawnEnemy():
	var enemy = m_enemyScene.instance()
	enemy.m_currentAngle = rand_range(0, 2 * PI)
	add_child(enemy)
	enemy.m_planet = get_parent()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("test"):
		spawnEnemy()
