extends Control

func _ready():
	add_to_group("leaderboard")
	
	# Create background panel
	var panel = Panel.new()
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel.modulate = Color(0, 0, 0, 0.8)  # Semi-transparent black
	add_child(panel)
	
	# Create leaderboard label
	var label = Label.new()
	label.name = "LeaderboardLabel"
	label.set_anchors_preset(Control.PRESET_CENTER)
	label.position = Vector2(960 - 200, 300)  # Center of 1920x1080
	label.add_theme_font_size_override("font_size", 48)
	label.add_theme_color_override("font_color", Color.WHITE)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(label)
	
	# No Play Again button - game ends at leaderboard
	
	# Hide by default
	hide()
