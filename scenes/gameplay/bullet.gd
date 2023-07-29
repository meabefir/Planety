extends PlanetOrbiter

const SPEED = 1000

var m_dir = 1

func _ready() -> void:
	m_planet = Globals.getSingle("planet")
	m_height = 40
	
	yield(get_tree().create_timer(4), "timeout")
	queue_free()

func _process(delta: float) -> void:
	m_horizontalVelocity = m_dir * SPEED
