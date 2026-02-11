extends Node

# Player character data - UPDATE THESE PATHS TO MATCH YOUR FILES
var players = [
	{
		"name": "Robot",
		"sprite_right": "res://Robot/robot_right.png",
		"sprite_left": "res://Robot/robot_left.png",
		"scale": 1.0,  # Robot base size - don't change
		"time": 0.0
	},
	{
		"name": "Dog",
		"sprite_right": "res://Laika/laika_right.png",
		"sprite_left": "res://Laika/laika_left.png",
		"scale": 1.0,  # ADJUST THIS: bigger = larger dog (try 1.0, 1.5, 2.0, etc.)
		"time": 0.0
	},
	{
		"name": "Astronaut",
		"sprite_right": "res://Astronaut/astronaut_right.png",
		"sprite_left": "res://Astronaut/astronaut_left.png",
		"scale": 1.0,  # ADJUST THIS: bigger = larger astronaut (try 1.0, 1.5, 2.0, etc.)
		"time": 0.0
	}
]
var current_player_index = 0
var is_countdown_active = false
var game_over = false

# References
var player_node: CharacterBody2D
var timer_ui
var countdown_label: Label
var leaderboard_ui: Control

func _ready():
	# We'll find these nodes when the game starts
	add_to_group("game_manager")
	call_deferred("setup_references")

func setup_references():
	player_node = get_tree().get_first_node_in_group("player")
	timer_ui = get_tree().get_first_node_in_group("timer")
	countdown_label = get_tree().get_first_node_in_group("countdown")
	leaderboard_ui = get_tree().get_first_node_in_group("leaderboard")
	
	if leaderboard_ui:
		leaderboard_ui.hide()
	
	# Don't load sprites for first player - they're already set in the scene
	print("GameManager ready. Player found: ", player_node != null)
	print("Timer found: ", timer_ui != null)

func load_player_sprites(player_index: int):
	if player_node == null:
		print("ERROR: player_node is null!")
		return
	
	if player_node.sprite == null:
		print("ERROR: player sprite is null!")
		return
	
	var player_data = players[player_index]
	
	# Load the textures
	var tex_right = load(player_data["sprite_right"])
	var tex_left = load(player_data["sprite_left"])
	
	if tex_right == null or tex_left == null:
		print("ERROR: Could not load textures for ", player_data["name"])
		print("  Right sprite path: ", player_data["sprite_right"])
		print("  Left sprite path: ", player_data["sprite_left"])
		return
	
	print("Loading sprites for ", player_data["name"])
	
	# Directly update the sprite texture
	player_node.sprite.texture = tex_right
	
	# Update the exported variables so direction switching works
	player_node.sprite_right = tex_right
	player_node.sprite_left = tex_left
	
	print("Successfully loaded sprites for ", player_data["name"])

func on_player_death():
	if game_over:
		return
	
	# Save the current player's time
	if timer_ui:
		var time = timer_ui.time_elapsed
		players[current_player_index]["time"] = time
		print("Player ", current_player_index, " (", players[current_player_index]["name"], ") died. Time: ", time)
	else:
		print("ERROR: timer_ui not found!")
	
	# Check if this was the last player
	if current_player_index >= players.size() - 1:
		# Game over - show leaderboard
		show_leaderboard()
	else:
		# Start countdown for next player
		start_countdown()

func start_countdown():
	is_countdown_active = true
	
	# Stop the timer during countdown
	if timer_ui:
		print("Stopping timer. Current time: ", timer_ui.time_elapsed)
		timer_ui.is_running = false
	else:
		print("ERROR: timer_ui not found during countdown!")
	
	# Pause meteor spawning
	var meteor_spawner = get_tree().get_first_node_in_group("meteor_spawner")
	if meteor_spawner and meteor_spawner.has_method("pause_spawning"):
		meteor_spawner.pause_spawning()
	
	# Disable player controls
	if player_node:
		player_node.set_physics_process(false)
	
	# Show countdown
	if countdown_label:
		countdown_label.show()
		await countdown_3_2_1()
		countdown_label.hide()
	else:
		await get_tree().create_timer(3.0).timeout
	
	# Move to next player
	current_player_index += 1
	switch_to_next_player()

func countdown_3_2_1():
	if countdown_label:
		countdown_label.text = "3"
		await get_tree().create_timer(1.0).timeout
		countdown_label.text = "2"
		await get_tree().create_timer(1.0).timeout
		countdown_label.text = "1"
		await get_tree().create_timer(1.0).timeout

func switch_to_next_player():
	print("Switching to player ", current_player_index, " (", players[current_player_index]["name"], ")")
	
	# Reset player position and health
	if player_node:
		player_node.position = Vector2(960, 100)  # Adjust starting position
		player_node.current_health = player_node.max_health
		player_node.is_invincible = false
		player_node.velocity = Vector2.ZERO
		player_node.set_physics_process(true)
	
	# Reset timer - Direct access to fix the reset issue
	if timer_ui:
		print("Resetting timer. Current time before reset: ", timer_ui.time_elapsed)
		timer_ui.time_elapsed = 0.0
		timer_ui.is_running = true
		timer_ui.update_display()
		print("Timer reset complete. New time: ", timer_ui.time_elapsed)
	else:
		print("ERROR: timer_ui not found during switch!")
	
	# Reset meteor spawner
	var meteor_spawner = get_tree().get_first_node_in_group("meteor_spawner")
	if meteor_spawner and meteor_spawner.has_method("reset_difficulty"):
		meteor_spawner.reset_difficulty()
	
	# Load new character sprites
	load_player_sprites(current_player_index)
	
	is_countdown_active = false

func show_leaderboard():
	game_over = true
	
	# Stop everything
	if player_node:
		player_node.set_physics_process(false)
	if timer_ui:
		timer_ui.is_running = false
	
	# Show leaderboard UI
	if leaderboard_ui:
		leaderboard_ui.show()
		update_leaderboard_display()

func update_leaderboard_display():
	if leaderboard_ui == null:
		return
	
	# Sort players by time (longest time = best)
	var sorted_players = players.duplicate()
	sorted_players.sort_custom(func(a, b): return a["time"] > b["time"])
	
	# Update leaderboard text
	var leaderboard_label = leaderboard_ui.get_node_or_null("LeaderboardLabel")
	if leaderboard_label:
		var text = "=== LEADERBOARD ===\n\n"
		for i in range(sorted_players.size()):
			var player = sorted_players[i]
			var minutes = int(player["time"]) / 60
			var seconds = int(player["time"]) % 60
			var milliseconds = int((player["time"] - int(player["time"])) * 100)
			text += "%d. %s - %02d:%02d:%02d\n" % [i + 1, player["name"], minutes, seconds, milliseconds]
		leaderboard_label.text = text

func restart_game():
	get_tree().reload_current_scene()
