extends PlanetOrbiter

const TOP_SPEED = 1400.0
const BASE_SPEED = 250.0
const ACC = 25.0
const DEC = 70.0
const JUMP_FORCE = 800.0
const G = 20.0

const MAX_HP = 200.0

onready var bulletScene = preload("res://scenes/gameplay/bullet.tscn")

onready var m_player = Globals.getSingle("player")

onready var m_healthBar: TextureProgress = $"%health_bar"

var m_velocity: Vector2 = Vector2.ZERO	
export var health: float = 50

var m_currentHp = MAX_HP setget setHp

var timer = 0.0 

func setHp(val):
	m_currentHp = max(0, min(MAX_HP, val))
	m_healthBar.value = (m_currentHp / MAX_HP) * (m_healthBar.max_value - m_healthBar.min_value)
	if val < 0:
		queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	m_planet = Globals.getSingle("planet")
	m_currentAngle = -PI / 2
	m_horizontalVelocity = 100
	
func _process(delta: float) -> void:
	updateDirToPlayer(delta)
	timer += 2 * delta
	if timer < 0.5:
		shootAction()

func shootAction():
	if m_height != 0:
		return
	var _dir = sign(m_velocity.x)
	if _dir == 0:
		return
	
	var new_bullet = bulletScene.instance()
	new_bullet.m_currentAngle = m_currentAngle
	new_bullet.m_dir = _dir
	new_bullet.m_planet = Globals.getSingle("planet")
	new_bullet.m_height = 40
	Globals.getSingle("projectiles").add_child(new_bullet)

func updateDirToPlayer(delta:float):
	var dir_this_frame = sign(Ranges.circShortestDiff(m_currentAngle, m_player.m_currentAngle, 0, 2 * PI))
	m_velocity.x += dir_this_frame * 40* delta
	return dir_this_frame
	
func _on_Area2D_area_entered(area: Area2D) -> void:
	#Globals.getSingle("player").spawnHalfPlayer = false
	queue_free()
