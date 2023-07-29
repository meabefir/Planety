extends Node2D


export var startPos : Vector2 = position

func _ready() -> void:
	var endPos = startPos + Vector2(0, -100)
	$GoUpTween.interpolate_property(self, "position", position, endPos, 5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$GoUpTween.interpolate_property(self, "rotation_degrees", 0, 5, 5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$GoUpTween.start()

func _on_GoUpTween_tween_completed(_object: Object, _key: NodePath) -> void:
	 $GoDownTween.interpolate_property(self, "position", position, startPos, 5, Tween.TRANS_QUAD, Tween.EASE_IN)
	 $GoDownTween.interpolate_property(self, "rotation_degrees", 5, 0, 5, Tween.TRANS_QUAD, Tween.EASE_IN)
	 $GoDownTween.start()
