extends PlanetOrbiter

const SPEED = 350
const JUMP_FORCE = 800
const G = 20

onready var bulletScene = preload("res://scenes/gameplay/bullet.tscn")

var m_velocity: Vector2 = Vector2.ZERO	
export var health: float = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	m_planet = Globals.getSingle("planet")
	
	m_currentAngle = -PI / 2

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		if m_height != 0:
			return
		var _dir = sign(m_velocity.x)
		if _dir == 0:
			return
		
		var new_bullet = bulletScene.instance()
		new_bullet.m_currentAngle = m_currentAngle
		new_bullet.m_dir = _dir
		Globals.getSingle("projectiles").add_child(new_bullet)

func _process(delta: float) -> void:
	var vec_input = Vector2.ZERO
	if Input.is_action_pressed("left"):
		vec_input.x -= 1
	if Input.is_action_pressed("right"):
		vec_input.x += 1
	m_velocity.x = vec_input.x * SPEED
	
	m_horizontalVelocity = m_velocity.x
	m_verticalVelocity = m_velocity.y
	
	if Input.is_action_just_pressed("jump"):
		if m_height == 0:
			jump(delta)
			return
			
	if m_height > 0:
		m_velocity.y -= G
	elif m_height < 0:
		m_velocity.y = 0
	
func jump(delta):
	m_velocity.y = JUMP_FORCE

