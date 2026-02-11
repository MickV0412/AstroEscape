extends Label

var time_elapsed = 0.0
var is_running = true

func _ready():
	# Position the label at the top center
	position = Vector2(640, 20)  # Adjust if needed
	add_theme_font_size_override("font_size", 32)
	
func _process(delta):
	if is_running:
		time_elapsed += delta
		update_display()

func update_display():
	var minutes = int(time_elapsed) / 60
	var seconds = int(time_elapsed) % 60
	var milliseconds = int((time_elapsed - int(time_elapsed)) * 100)
	
	text = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]

func stop_timer():
	is_running = false

func reset_timer():
	time_elapsed = 0.0
	is_running = true
	update_display()
