extends PlanetOrbiter

<<<<<<< Updated upstream
const MAX_HP = 21.0
const SPEED = 150.0
const MIN_PUSH_FORCE = 70.0
const PUSH_FORCE = 150.0
const DAMAGE = 3.0
=======
const MAX_HP = 200.0
const SPEED = 150.0
const MIN_PUSH_FORCE = 70.0
const PUSH_FORCE = 150.0
const DAMAGE = 25.0
>>>>>>> Stashed changes
const HIT_COOLDOWN = 2.0

enum ENEMY_STATE {
	SPAWNING,
	DEFAULT,
	DIE
}

var m_velocity = Vector2.ZERO

onready var m_player = null
onready var pushArea: Area2D = $"push_area"
onready var healthBar = $"%health_bar"
onready var tween: Tween = $"%Tween"
onready var hurtbox = $"%hurtbox"
onready var sprite = $"%sprite"

var pushAreaTimer

var currentHp = MAX_HP setget setHp
var currentState = ENEMY_STATE.SPAWNING setget setState

var spawnProgress = 0.0

var canHit = true
var hitTimer = 0

func setState(value):
	var old_state = currentState
	
	currentState = value
	
	match currentState:
		ENEMY_STATE.DIE:
			print("DIE")
			m_horizontalVelocity = 0
			hurtbox.set_deferred("monitorable", false)
			pushArea.set_deferred("monitorable", false)
			sprite.material.set_shader_param("u_die", true)
			tween.interpolate_method(self, "updateDeathProgress", 0, 5, .5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			tween.connect("tween_completed", self, "tweenCompleted")

func setHp(value):
	currentHp = min(MAX_HP, max(0, value))
	healthBar.material.set_shader_param("u_hpPerc", currentHp / MAX_HP)
	
#	if tween.is_active():
#		tween.stop_all(
	tween.stop(self, "modulate")
	tween.interpolate_property(healthBar, "modulate", 
	  Color(1,1,1,1), Color(1,1,1,0), 1.0, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	
	if value <= 0:
		die()

func die():
	self.currentState = ENEMY_STATE.DIE
#	queue_free()

func tweenCompleted(obj, prop):
	print(obj, prop)
	if prop == ":updateDeathProgress":
		queue_free()

func updateDeathProgress(val):
	sprite.material.set_shader_param("u_dieProgress", val)

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
	
	if !canHit:
		hitTimer += delta
		if hitTimer >= HIT_COOLDOWN:
			canHit = true
			hitTimer = 0.0
	
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

func _on_hitbox_area_entered(area: Area2D) -> void:
	if !canHit:
		return
	var player = area.get_parent()
	if area is Hurtbox:
		player.collision({
			"from": "enemy",
			"damage": DAMAGE
		})
