extends Sprite

export var spin_speed: float = 9.0
var current_rotation: float = 0.0

func _process(delta: float) -> void:
	current_rotation += spin_speed * delta
	rotation_degrees = current_rotation
