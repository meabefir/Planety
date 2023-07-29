extends PlanetOrbiter

const SPEED = 250
const JUMP_FORCE = 100
const G = 10

var m_velocity: Vector2 = Vector2.ZERO	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	m_planet = get_parent()
	
	m_currentAngle = -PI / 2

func _process(delta: float) -> void:
	var vec_input = Vector2.ZERO
	if Input.is_action_pressed("left"):
		vec_input.x -= 1
	if Input.is_action_pressed("right"):
		vec_input.x += 1
	
	m_horizontalVelocity = vec_input.x * SPEED
	m_verticalVelocity = m_velocity.y
	
	if Input.is_action_just_pressed("jump"):
		if m_height == 0:
			jump(delta)
			return
			
#	print(m_height, " ", m_velocity.y)
	if m_height > 0:
		m_velocity.y -= G * delta
	else:
		m_velocity.y = 0
#	print(m_velocity.y)
	
func jump(delta):
	m_velocity.y = JUMP_FORCE
