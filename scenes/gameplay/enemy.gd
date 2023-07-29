extends PlanetOrbiter

const SPEED = 150
const MIN_PUSH_FORCE = 70
const PUSH_FORCE = 150

var bullet_hit = false

export var health: float = 50

var m_velocity = Vector2.ZERO

onready var m_player = Globals.getSingle("player")
onready var pushArea: Area2D = $"push_area"

var pushAreaTimer

func _ready():
	pass
	m_currentAngle = rand_range(0, 2 * PI)

	pushAreaTimer = Timer.new()
	pushAreaTimer.wait_time = .5
	pushAreaTimer.autostart = true
	pushAreaTimer.connect("timeout", self, "activatePushArea", [], CONNECT_ONESHOT)
	add_child(pushAreaTimer)
	
func activatePushArea():
	pushArea.monitorable = true
	pushAreaTimer.queue_free()
	
func _process(delta: float) -> void:
	m_velocity.x = 0
	
	updateDirToPlayer()
	
	var overlapping_enemies = pushArea.get_overlapping_areas()
	for area in overlapping_enemies:
		var enemy = area.get_parent()
		var diff_to_enemy = Ranges.circShortestDiff(m_currentAngle, enemy.m_currentAngle, 0, 2 * PI)
		var dir_to_enemy = sign(diff_to_enemy)
		var push = dir_to_enemy * (min(1, 1.3 - m_planet.angleToArc(abs(diff_to_enemy)) / 67)) * PUSH_FORCE
		m_velocity.x -= push
		
	m_horizontalVelocity = m_velocity.x
	
func updateDirToPlayer():
	var dir_this_frame = sign(Ranges.circShortestDiff(m_currentAngle, m_player.m_currentAngle, 0, 2 * PI))
	
	m_velocity.x += dir_this_frame * SPEED
	
func _is_dead():
	if bullet_hit == true:
		self.queue_free()
