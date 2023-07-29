extends Node2D

export var startPos : Vector2 = position

func _ready() -> void:
	var endPos = startPos + Vector2(0, -50)
	$GoUpTween.interpolate_property(self, "position", position, endPos, 3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$GoUpTween.interpolate_property(self, "rotation_degrees", 0, 5, 3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$GoUpTween.start()

func _on_GoUpTween_tween_completed(_object: Object, _key: NodePath) -> void:
	 $GoDownTween.interpolate_property(self, "position", position, startPos, 3, Tween.TRANS_QUAD, Tween.EASE_IN)
	 $GoDownTween.interpolate_property(self, "rotation_degrees", 5, 0, 3, Tween.TRANS_QUAD, Tween.EASE_IN)
	 $GoDownTween.start()

func _on_BottleShape_body_entered(body: Node) -> void:
	print("Collision")

func _on_BottleShape_body_exited(body: Node) -> void:
	print("Bunaaaa")

func _on_GoDownTween_tween_all_completed() -> void:
	queue_free()

func _on_BottleShape_area_entered(area: Area2D) -> void:
	print("Collision")
