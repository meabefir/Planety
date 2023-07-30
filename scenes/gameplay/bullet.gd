extends PlanetOrbiter

const SPEED = 1000
const DAMAGE = 6.66

var m_dir = 1
export var m_currentSpeed = SPEED

onready var m_sprite = get_node("Sprite")

var currentHp = 211

func _ready() -> void:
	m_sprite.flip_v = true if m_dir == -1 else false

	yield(get_tree().create_timer(4), "timeout")
	die()
#	queue_free()

func die():
	var tw = Tween.new()
	tw.interpolate_property(self, "m_height", m_height, 0, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tw.interpolate_property(self, "m_currentSpeed", SPEED, 0, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	add_child(tw)
	tw.start()
	
	tw.connect("tween_all_completed", self, "queue_free")

func _process(delta: float) -> void:
	m_horizontalVelocity = m_dir * m_currentSpeed

func _on_Area2D_area_entered(area: Area2D) -> void:
	area.collision({
		"damage": DAMAGE,
		"from": "bullet"
	})
	
	currentHp -= 1
	if currentHp == 0:
		queue_free()
