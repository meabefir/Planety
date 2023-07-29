extends Node2D

onready var m_enemyScene = preload("res://scenes/gameplay/enemy.tscn")

func _ready():
#	return
	for i in range (0, 100):
		var enemy = m_enemyScene.instance()
		add_child(enemy)
		enemy.m_planet = get_parent()
