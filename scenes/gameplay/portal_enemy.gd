extends PlanetOrbiter

const MAX_HP = 100
const SPEED = 100
const MIN_PUSH_FORCE = 70
const PUSH_FORCE = 150
const DAMAGE = 5
const SUMMON_COOLDOWN = 3.0

enum ENEMY_STATE {
	SPAWNING,
	DEFAULT
}

onready var portalScene = preload("res://scenes/gameplay/portal.tscn")

onready var m_player = null
onready var pushArea: Area2D = $"push_area"
onready var healthBar = $"%health_bar"
onready var tween: Tween = $"%Tween"
onready var hurtbox = $"%hurtbox"
onready var sprite = $"%sprite"
onready var portalNotifier = $"%portal_notifier"

var pushAreaTimer

var m_velocity = Vector2.ZERO
var currentHp = MAX_HP setget setHp
var currentState = ENEMY_STATE.SPAWNING setget setState

var spawnProgress = 0.0

var canSummonPortal = true
var summonProgress = 0

var summonedPortalForBullets = []

var manaProgress = 1.0

func setState(value):
	var old_state = currentState
	
	currentState = value
	

func setHp(value):
	currentHp = min(MAX_HP, max(0, value))
	healthBar.material.set_shader_param("u_hpPerc", currentHp / MAX_HP)
	
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(healthBar, "modulate", 
	  Color(1,1,1,1), Color(1,1,1,0), 1.0, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	
	if value <= 0:
		die()

func die():
	queue_free()

func _ready():
	m_player = Globals.getSingle("player")
	
	pushAreaTimer = Timer.new()
	pushAreaTimer.wait_time = .5
	pushAreaTimer.autostart = true
	pushAreaTimer.connect("timeout", self, "activatePushArea", [], CONNECT_ONESHOT)
	add_child(pushAreaTimer)
	
	self.currentHp = MAX_HP
	
	hurtbox.connect("collision", self, "collision")
	
	sprite.material.set_shader_param("u_spawnProgress", 0)
	
func collision(data):
	var damage = data["damage"]
	self.currentHp -= damage
	
func activatePushArea():
	pushArea.monitorable = true
	pushAreaTimer.queue_free()
	
func _process(delta: float) -> void:
	match currentState:
		ENEMY_STATE.SPAWNING:
			updateStateSpawning(delta)
		ENEMY_STATE.DEFAULT:
			updateStateDefault(delta)
			
	sprite.flip_h = sign(m_horizontalVelocity) == -1
	portalNotifier.material.set_shader_param("u_progress", manaProgress)
#	print(manaProgress)
	if !canSummonPortal:
		summonProgress += delta
		if summonProgress >= SUMMON_COOLDOWN:
			summonProgress = 0.0
			canSummonPortal = true
	
func updateStateSpawning(delta):
	spawnProgress += delta
	spawnProgress = min(1, spawnProgress)

	sprite.material.set_shader_param("u_spawnProgress", spawnProgress)	
	
	if spawnProgress >= 1.0:
		self.currentState = ENEMY_STATE.DEFAULT
	
func updateStateDefault(delta):
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
	if !is_instance_valid(m_player):
		m_velocity.x += sign(m_horizontalVelocity) * SPEED / 2
		return
	var dir_this_frame = sign(Ranges.circShortestDiff(m_currentAngle, m_player.m_currentAngle, 0, 2 * PI))
	
	m_velocity.x += dir_this_frame * SPEED


func _on_bullet_detector_area_entered(area: Area2D) -> void:
	var bullet = area.get_parent()
	if canSummonPortal and not bullet in summonedPortalForBullets and sign(bullet.m_horizontalVelocity) != sign(m_horizontalVelocity):
#	if canSummonPortal and not bullet in summonedPortalForBullets and \
#	 sign(m_horizontalVelocity) == sign(Ranges.circShortestDiff(bullet.m_currentAngle, m_currentAngle)):
		summonPortal(bullet)
	
func summonPortal(bullet):
	tween.interpolate_property(self, "manaProgress", 0, 1, SUMMON_COOLDOWN, Tween.TRANS_EXPO, Tween.EASE_IN)
	tween.start()
	
	canSummonPortal = false
	summonedPortalForBullets.append(bullet)
	var dir = Ranges.circShortestDiff(m_currentAngle, bullet.m_currentAngle)
	
	var distance_to_bullet = m_planet.angleToArc(abs(dir), bullet.m_height)
	if distance_to_bullet < 75:
		return
	
	dir = sign(dir)
	var portal_angle = m_currentAngle + m_planet.arcToAngle(min(150, max(75, distance_to_bullet)) * dir)
	
	var new_portal = portalScene.instance()
	new_portal.dir = dir
	new_portal.m_currentAngle = portal_angle
	var misc = Globals.getSingle("misc")
	
	misc.call_deferred("add_child", new_portal)
