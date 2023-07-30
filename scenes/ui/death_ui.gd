extends ColorRect

onready var messageLabel = $"%death_message_label"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	pass # Replace with function body.
	
func updateData(from):
	var text = ""
	if from == "bullet":
		text = "Get gunned down"
	elif from == "guillotine":
		text = "Even the mighty must bow their head"
	elif from == "enemy":
		text = "The most embarrassing death..."
	elif from == "portal_enemy":
		text = "Slain by a wizard"
	
	messageLabel.text = text
