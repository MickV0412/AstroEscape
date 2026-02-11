extends Label

func _ready():
	add_to_group("countdown")
	
	# Center on screen
	position = Vector2(960 - size.x / 2, 540 - size.y / 2)  # Center of 1920x1080
	
	# Make it big and visible
	add_theme_font_size_override("font_size", 128)
	add_theme_color_override("font_color", Color.YELLOW)
	add_theme_color_override("font_outline_color", Color.BLACK)
	add_theme_constant_override("outline_size", 5)
	
	# Hide by default
	hide()
