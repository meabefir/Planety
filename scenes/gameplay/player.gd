extends PlanetOrbiter

const TOP_SPEED = 1400.0
const BASE_SPEED = 250.0
const ACC = 25.0
const DEC = 35.0
const JUMP_FORCE = 800.0
const G = 20.0

const MAX_HP = 200.0

onready var bulletScene = preload("res://scenes/gameplay/bullet.tscn")

onready var m_healthBar: TextureProgress = $"%health_bar"

var m_velocity: Vector2 = Vector2.ZERO	
export var health: float = 50

var m_currentHp = MAX_HP setget setHp

func setHp(val):
	m_currentHp = max(0, min(MAX_HP, val))
	m_healthBar.value = (m_currentHp / MAX_HP) * (m_healthBar.max_value - m_healthBar.min_value)
	if val < 0:
		die()

func die():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	m_planet = Globals.getSingle("planet")
	
	m_currentAngle = -PI / 2
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		shootAction()
	
	if Input.is_action_just_pressed("test"):
		self.m_currentHp -= 10

func _process(delta: float) -> void:
	var vec_input = Vector2.ZERO
	if Input.is_action_pressed("left"):
		vec_input.x -= 1
	if Input.is_action_pressed("right"):
		vec_input.x += 1
	
	if Input.is_action_pressed("jump"):
		if m_height == 0:
			jump()
	
	if vec_input.x != 0:
		if vec_input.x == m_velocity.x:
			m_velocity.x = move_toward(m_velocity.x, vec_input.x * TOP_SPEED, ACC)
		else:
			m_velocity.x = move_toward(m_velocity.x, vec_input.x * TOP_SPEED, DEC)
	else:
		m_velocity.x = move_toward(m_velocity.x, 0, DEC)
	
	m_horizontalVelocity = m_velocity.x
	m_verticalVelocity = m_velocity.y
	
	if m_height > 0:
		m_velocity.y -= G
	elif m_height < 0:
		m_velocity.y = 0
	
	m_planet.m_currentAngle -= deg2rad(m_velocity.x / 20 * delta)
	
func jump():
	m_velocity.y = JUMP_FORCE

func shootAction():
	if m_height != 0:
		return
	var _dir = sign(m_velocity.x)
	if _dir == 0:
		return
	
	var new_bullet = bulletScene.instance()
	new_bullet.m_currentAngle = m_currentAngle
	new_bullet.m_dir = _dir
	Globals.getSingle("projectiles").add_child(new_bullet)
