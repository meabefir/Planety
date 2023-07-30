extends Control

onready var deathUi = $"%death_ui"
onready var uiAnimation = $"%ui_animation"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func die(from):
	print("here")
	deathUi.updateData(from)
	deathUi.visible = true
