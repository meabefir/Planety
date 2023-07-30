extends PlanetOrbiter

const N_TELEPORT_COUNT = 3

onready var portalScene = load("res://scenes/gameplay/portal.tscn")

onready var sprite = $"%Sprite"
onready var collShape = $"%coll_shape"
onready var area = get_node("area")

export var blueColor: Color
export var orangeColor: Color

var type = 0

var progress = 0.0
var dir = 1

var lifeTime = 2.0
var lifeTimer = 0.0
var fadeOut = false

var orangePortal = null
var currentTeleportCount = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var color = blueColor
	if type != 0:
		color = orangeColor
		
	if type == 1:
		area.set_deferred("monitoring", false)
	
	sprite.material.set_shader_param("u_color", color)
	
	if dir == -1:
		sprite.flip_h = true
		
#	# spawn orange portal
#	if type == 0:
#		pass
#	elif type == 1:
#		pass
	
func _process(delta: float) -> void:
	if !fadeOut:
		lifeTimer += delta
		if lifeTimer >= lifeTime:
			fadeOut = true
		
		progress += delta * 5.0
		progress = min(1.0, progress)
	else:
		progress -= delta * 2.0
		if progress <= 0.0:
			queue_free()
	
	sprite.material.set_shader_param("u_progress", progress)
	
func _on_area_area_entered(area: Area2D) -> void:
	var bullet = area.get_parent()
	if orangePortal == null:
		orangePortal = portalScene.instance()
		orangePortal.type = 1
		orangePortal.dir = dir * -1
		
		var angle = m_currentAngle + m_planet.arcToAngle(dir * 300)
		var player = Globals.getSingle("player")
		if is_instance_valid(player):
			angle = player.m_currentAngle + m_planet.arcToAngle(dir * 400)
		orangePortal.m_currentAngle = angle
		
		var misc = Globals.getSingle("misc")
		misc.call_deferred("add_child", orangePortal)
	
	orangePortal.teleport(bullet)
	
	currentTeleportCount += 1
	if currentTeleportCount >= N_TELEPORT_COUNT:
		queue_free()
	
func teleport(bullet):
	bullet.currentHp = 1
	bullet.m_currentSpeed *= .8
	bullet.m_currentAngle = m_currentAngle
	bullet.enable()
