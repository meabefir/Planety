extends Node2D


func _ready() -> void:
	get_tree().get_root().connect("size_changed", self, "onScreenResize")

func onScreenResize():
	print(get_viewport_rect().size)

func restart():
	get_tree().reload_current_scene()

func quit():
	get_tree().quit()

