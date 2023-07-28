extends Node2D

var startPos = Vector2.ZERO
var endPos = startPos + Vector2(0, -100)
func _ready() -> void:
	$GoUpTween.interpolate_property(self, "position", startPos, endPos, 5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$GoUpTween.interpolate_property(self, "rotation_degrees", 0, 5, 5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$GoUpTween.start()

func _on_GoUpTween_tween_completed(object: Object, key: NodePath) -> void:
	 $GoDownTween.interpolate_property(self, "position", endPos, startPos, 5, Tween.TRANS_QUAD, Tween.EASE_IN)
	 $GoDownTween.interpolate_property(self, "rotation_degrees", 5, 0, 5, Tween.TRANS_QUAD, Tween.EASE_IN)
	 $GoDownTween.start()
