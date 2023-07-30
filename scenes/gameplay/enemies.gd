extends Node2D

const N_MAX_ENEMIES = 10

onready var m_enemyScene = preload("res://scenes/gameplay/enemy.tscn")
export var health: float = 50

func _ready():
	pass
	
func spawnEnemy(angle = null):
	var player = Globals.getSingle("player")
	if !is_instance_valid(player):
		return
		
	var enemy = m_enemyScene.instance()
	if angle == null:
		enemy.m_currentAngle = player.m_currentAngle + (randi() % 2 * 2 - 1) * rand_range(PI/4, PI)
	else:
		enemy.m_currentAngle = angle
	add_child(enemy)
	enemy.m_planet = get_parent()

func _input(event: InputEvent) -> void:
	pass
#	if Input.is_action_just_pressed("test"):
#		spawnRandomWave(5)

func _on_enemy_spawn_timer_timeout() -> void:
	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies.size() < N_MAX_ENEMIES:
		spawnEnemy()

func spawnRandomWave(enemy_count):
	var angle = rand_range(0, 2 * PI)
	for i in range(enemy_count):
		spawnEnemy(angle + i * Globals.getSingle("planet").arcToAngle(30))
		yield(get_tree().create_timer(.05), "timeout")
