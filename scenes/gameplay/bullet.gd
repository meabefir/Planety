extends PlanetOrbiter

const LIFE_TIME = 5.5
const SPEED = 1000.0
const DAMAGE = 7

var m_dir = 1
export var m_currentSpeed = SPEED

onready var m_sprite = get_node("Sprite")
onready var collShape = $"%coll_shape"
onready var area = get_node("Area2D")

var disabled = false
var lifeTimer = 0
var currentHp = 35

func _ready() -> void:
	m_sprite.flip_v = true if m_dir == -1 else false

#	queue_free()

func die():
	var tw = Tween.new()
	add_child(tw)
	tw.start()
	
	tw.connect("tween_all_completed", self, "queue_free")

func _process(delta: float) -> void:
	if disabled:
		return
		
	lifeTimer += delta
	if lifeTimer >= LIFE_TIME:
		queue_free()
	m_horizontalVelocity = m_dir * m_currentSpeed

func _on_Area2D_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		area.collision({
			"damage": DAMAGE,
			"from": "bullet"
		})
		currentHp -= 1
		if currentHp == 0:
			queue_free()

func disable():
	visible = false
	disabled = true
	area.monitoring = false
	m_horizontalVelocity = 0.0

func enable():
	visible = true
	disabled = false
	area.monitoring = true
