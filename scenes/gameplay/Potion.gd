extends PlanetOrbiter

const START_VELOCITY = 300

func _ready() -> void: 
	visible = true
	m_planet = Globals.getSingle("planet")
	
	$GoUpTween.interpolate_property(self, "m_verticalVelocity", START_VELOCITY, 0, 3, Tween.TRANS_QUAD, Tween.EASE_IN)
	$GoUpTween.interpolate_property(self, "rotation_degrees", 0, 5, 3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$GoUpTween.start()

func _on_GoUpTween_tween_completed(_object: Object, _key: NodePath) -> void:
	 $GoDownTween.interpolate_property(self, "m_verticalVelocity", 0, -START_VELOCITY, 3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	 $GoDownTween.interpolate_property(self, "rotation_degrees", 5, 0, 3, Tween.TRANS_QUAD, Tween.EASE_IN)
	 $GoDownTween.start()

func _on_GoDownTween_tween_all_completed() -> void:
	queue_free()

func _on_BottleShape_area_entered(area: Area2D) -> void:
	queue_free()
	
	var player = Globals.getSingle("player")
	player.health += 10
	
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.health += 10
