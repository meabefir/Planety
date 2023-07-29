extends Node2D

func _ready():
	var scene = load("res://scenes/gameplay/enemy.tscn") 
	return
	for i in range (0, 5):
		var enemy = scene.instance()
		add_child(enemy)
		print ('sdadsa')
		enemy.m_planet = get_parent()
	
