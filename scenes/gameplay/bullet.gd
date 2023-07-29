extends PlanetOrbiter

const SPEED = 1000

var m_dir = 1

onready var m_sprite = get_node("Sprite")

func _ready() -> void:
	m_sprite.flip_v = true if m_dir == -1 else false
	
	yield(get_tree().create_timer(4), "timeout")
	queue_free()

func _process(delta: float) -> void:
	m_horizontalVelocity = m_dir * SPEED
