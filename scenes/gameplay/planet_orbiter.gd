extends Node2D

class_name PlanetOrbiter

var m_planet = null

var m_horizontalVelocity: float
var m_verticalVelocity: float

var m_height = 0
var m_currentAngle = 0

var m_keepOnGround = true

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	# move on x
	var planet_circumference = m_planet.radius * 2 * PI
	var horizontal_movement = m_horizontalVelocity * delta
	var circ_perc = abs(horizontal_movement / planet_circumference)
	m_currentAngle += sign(m_horizontalVelocity) * circ_perc * 2 * PI
	
	m_height += m_verticalVelocity * delta
	if m_keepOnGround and m_height < 0:
		m_height = 0
	
	var real_angle = m_planet.m_currentAngle + m_currentAngle
	global_rotation_degrees = rad2deg(real_angle + PI / 2)
	global_position = m_planet.global_position + Vector2(cos(real_angle), sin(real_angle)) * (m_planet.radius + m_height)

func isBelowGround():
	pass
