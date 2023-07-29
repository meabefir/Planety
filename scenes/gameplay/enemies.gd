extends Node2D

onready var m_enemyScene = preload("res://scenes/gameplay/enemy.tscn")

func _ready():
	for i in range (0, 10):
		spawnEnemy()
	
func spawnEnemy():
	var enemy = m_enemyScene.instance()
	add_child(enemy)
	enemy.m_planet = get_parent()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("test"):
		pass
