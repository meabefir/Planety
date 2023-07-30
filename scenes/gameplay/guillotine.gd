extends PlanetOrbiter

enum GUILLOTINE_STATE {
	SPAWNING,
	WANDER,
	NOTICE,
	RECOVER_TO_WANDER,
	CHARGE
}

const WANDER_HEIGHT = 250.0
const WANDER_SPEED = 600.0
const NOTICE_SPEED = 200.0
const NOTICE_SPEED_HEIGHT = 150.0
const CHARGE_SPEED = 350.0
const CHARGE_DAMAGE = 15.0
const DAMAGE_TO_SPLIT = 3 * CHARGE_DAMAGE
const MAX_HP = 150.0

onready var animationPlayer = get_node("AnimationPlayer")
onready var warningSprite = $"%warning"
onready var noticeArea: Area2D = $"%notice_area"
onready var noticeCollision = $"%notice_collision"
onready var hitBox = $"%hit_box"
onready var hitboxCollision = $"%hitbox_collision"
onready var healthBar = $"%hp"
onready var hurtbox: Hurtbox = $"%hurtbox"

var currentState = GUILLOTINE_STATE.SPAWNING setget setState
var currentHp: float = MAX_HP setget setHp

func setHp(value):
	currentHp = clamp(value, 0.0, MAX_HP)
	
	healthBar.material.set_shader_param("u_lifePerc", float(currentHp / MAX_HP) * 2.0 * PI - PI)
	
	print(currentHp)
	if currentHp == 0:
		print("DUIE")
		print("DUIE")
		print("DUIE")
		print("DUIE")
		print("DUIE")
		get_tree().call_group("enemy", "die")
		Globals.getSingle("enemies").stop()
		queue_free()

var wanderTimer = 0.0
var noticeTimer = 0.0

var targetAngle = 0
var targetHeight = 0

var lastWanderAngle = 0
var lastWanderHeight = 0

var dir = 1

var damageToPlayerThisCharge = 0

func setState(value):
	var prev_state = currentState
	match prev_state:
		GUILLOTINE_STATE.WANDER:
			lastWanderAngle = m_currentAngle
			lastWanderHeight = m_height
		GUILLOTINE_STATE.NOTICE:
			noticeCollision.shape.radius = 10
		GUILLOTINE_STATE.RECOVER_TO_WANDER:
			warningSprite.visible = false
		GUILLOTINE_STATE.CHARGE:
#			hitboxCollision.disabled = true
			hitBox.monitoring = false
			if damageToPlayerThisCharge == 0:
				onChargeNoDamage()
			
	currentState = value
	
	match currentState:
		GUILLOTINE_STATE.SPAWNING:
			animationPlayer.play("spawn")
		GUILLOTINE_STATE.WANDER:
			dir = randi() % 2 * 2 - 1
#			warningSprite.visible = false
		GUILLOTINE_STATE.NOTICE:
			warningSprite.visible = true
			noticeTimer = 0
			warningSprite.material.set_shader_param("u_progress", 0) 
#			m_horizontalVelocity = 0.0
			noticeCollision.shape.radius = 13
		GUILLOTINE_STATE.RECOVER_TO_WANDER:
#			targetAngle = lastWanderAngle
#			targetHeight = lastWanderHeight
			targetAngle = m_currentAngle
			targetHeight = WANDER_HEIGHT
			wanderTimer = 0
		GUILLOTINE_STATE.CHARGE:
			m_verticalVelocity = 0
#			hitboxCollision.disabled = false
			hitBox.monitoring = true
			animationPlayer.play("charge")
			damageToPlayerThisCharge = 0
	
func _ready() -> void:
	m_planet = Globals.getSingle("planet")
	self.currentState = GUILLOTINE_STATE.SPAWNING
	
	m_keepOnGround = false
	warningSprite.visible = false
	
	hurtbox.connect("collision", self, "collision")
	
	healthBar.material.set_shader_param("u_lifePerc", PI)
	
func collision(data):
	self.currentHp -= data["damage"]
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("test"):
		onChargeNoDamage()
#	print(GUILLOTINE_STATE.keys()[currentState])
	match currentState:
		GUILLOTINE_STATE.SPAWNING:
			pass
			
		GUILLOTINE_STATE.WANDER:
			wanderTimer += delta
			m_horizontalVelocity = WANDER_SPEED * dir
			m_height = WANDER_HEIGHT + sin(wanderTimer * 2.0) * 150.0 \
									 + sin(wanderTimer * 4.0) * 75.0
									
		GUILLOTINE_STATE.NOTICE:
			noticeTimer += delta * .5
			noticeTimer = min(1.0, noticeTimer)
			if noticeTimer >= 1:
				self.currentState = GUILLOTINE_STATE.CHARGE
				return
				
			warningSprite.material.set_shader_param("u_progress", noticeTimer)
			
			var inters = noticeArea.get_overlapping_areas()
			if inters.size() == 0:
				self.currentState = GUILLOTINE_STATE.RECOVER_TO_WANDER
				return
			
			var player = inters[0].get_parent()
			
			targetAngle = player.m_currentAngle
			targetHeight = player.m_height
			
			followTarget(delta)
			
		GUILLOTINE_STATE.RECOVER_TO_WANDER:
			noticeTimer -= delta
			noticeTimer = max(0, noticeTimer)
			warningSprite.material.set_shader_param("u_progress", noticeTimer) 
			
			followTarget(delta, 1.0)
			
#			print(abs(m_currentAngle - targetAngle), abs(m_height - targetHeight))
#			if m_currentAngle == targetAngle and m_height == targetHeight:
			if reachedTarget():
				self.currentState = GUILLOTINE_STATE.WANDER
			
		GUILLOTINE_STATE.CHARGE:
			var side = sign(m_horizontalVelocity)
			if side == 0:
				side = randi() % 2 * 2 - 1
			m_horizontalVelocity = CHARGE_SPEED * side	
			
#			var player = Globals.getSingle("player")
#			if !is_instance_valid(player):
#				self.currentState = GUILLOTINE_STATE.RECOVER_TO_WANDER
#				return
#			targetAngle = player.m_currentAngle
#			targetHeight = 0
			
#			followTarget()

func reachedTarget():
#	print(abs(m_currentAngle-targetAngle), " ", abs(m_height - targetHeight))
	return is_equal_approx(m_currentAngle, targetAngle) and is_equal_approx(m_height, targetHeight)

func followTarget(delta, speed_multiply = 1.0):
	var dir_to_target = Ranges.circShortestDiff(m_currentAngle, targetAngle)
	var distance_to_move = abs(m_planet.angleToArc(dir_to_target))
	dir_to_target = sign(dir_to_target)
	var hor_speed = NOTICE_SPEED * speed_multiply
	if hor_speed * delta < distance_to_move:
		m_horizontalVelocity = hor_speed * dir_to_target
	else:
		m_horizontalVelocity = distance_to_move * dir_to_target / delta
		
	var height_diff = targetHeight - m_height
	var ver_speed = NOTICE_SPEED_HEIGHT * speed_multiply
	if ver_speed * delta < abs(height_diff):
		m_verticalVelocity = ver_speed * sign(height_diff)
	else:
		m_verticalVelocity = height_diff / delta

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		self.currentState = GUILLOTINE_STATE.WANDER
	elif anim_name == "charge":
		self.currentState = GUILLOTINE_STATE.RECOVER_TO_WANDER

func _on_hit_box_area_entered(area: Area2D) -> void:
#	hit player 
#	print("hit player")
	if area is Hurtbox:
		area.collision({
			"damage": CHARGE_DAMAGE,
			"from": "guillotine"
		})
		damageToPlayerThisCharge += CHARGE_DAMAGE
		if damageToPlayerThisCharge > DAMAGE_TO_SPLIT:
			splitPlayer()
	
func splitPlayer():
	print("split player")
#	Globals.getSingle("player").spawnHalfPlayer = true
	
func onChargeNoDamage():
	var angle = PI / 4.0
	Globals.getSingle("enemies").spawnWaveRelativeToPlayer(3, angle)
	Globals.getSingle("enemies").spawnWaveRelativeToPlayer(3, -angle)
	
func _on_notice_area_area_entered(area: Area2D) -> void:
	if not currentState in [GUILLOTINE_STATE.WANDER, GUILLOTINE_STATE.RECOVER_TO_WANDER]:
		return
	self.currentState = GUILLOTINE_STATE.NOTICE
