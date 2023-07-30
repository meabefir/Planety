extends Node2D

const N_MAX_BASIC_ENEMIES = 0
const N_MAX_PORTAL_ENEMIES = 2

onready var m_enemyScene = preload("res://scenes/gameplay/enemy.tscn")
onready var m_portalEnemyScene = preload("res://scenes/gameplay/portal_enemy.tscn")
export var health: float = 35

func _ready():
	pass
	
func spawnEnemy(angle = null, enemy_scene = m_enemyScene):
	var player = Globals.getSingle("player")
	if !is_instance_valid(player):
		return
		
	var enemy = enemy_scene.instance()
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

func spawnWaveRelativeToPlayer(count, angle):
	var player = Globals.getSingle("player")
	if !is_instance_valid(player):
		return
		
	var a = player.m_currentAngle + angle
#	print(rad2deg(player.m_currentAngle), " ", rad2deg(a))
	spawnRandomWave(count, a, sign(angle))

func spawnRandomWave(enemy_count, angle = null, dir=1):
	if angle == null:
		angle = rand_range(0, 2 * PI)
	for i in range(enemy_count):
		spawnEnemy(angle + i * Globals.getSingle("planet").arcToAngle(30) * dir)
		yield(get_tree().create_timer(.15), "timeout")

func _on_enemy_spawn_timer_timeout() -> void:
	var basic_enemies = get_tree().get_nodes_in_group("basic_enemy")
	if basic_enemies.size() < N_MAX_BASIC_ENEMIES:
		spawnEnemy()

func _on_portal_enemy_spawn_timer_timeout() -> void:
	var enemies = get_tree().get_nodes_in_group("portal_enemy")
	if enemies.size() < N_MAX_PORTAL_ENEMIES:
		spawnEnemy(null, m_portalEnemyScene)
