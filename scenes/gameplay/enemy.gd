extends PlanetOrbiter

var bullet_hit = false

func _ready():
	pass
	
func _is_dead():
	if bullet_hit == true:
		self.queue_free()
