extends Node2D

# Reference to the meteor scene (you'll set this in the Inspector)
@export var meteor_scene: PackedScene

# Spawning parameters
@export var spawn_width = 1920.0  # Width of the game window
@export var initial_spawn_interval = 2.0  # Start spawning every 2 seconds
@export var min_spawn_interval = 0.1  # Fastest spawn rate
@export var interval_decrease_rate = 0.05  # How much faster it gets over time

# Speed parameters
@export var initial_meteor_speed = 150.0
@export var max_meteor_speed = 600.0
@export var speed_increase_rate = 10.0  # How much faster meteors get over time

# Current values
var current_spawn_interval = initial_spawn_interval
var current_meteor_speed = initial_meteor_speed
var time_since_last_spawn = 0.0
var game_time = 0.0
var is_paused = false

func _ready():
	current_spawn_interval = initial_spawn_interval
	current_meteor_speed = initial_meteor_speed
	add_to_group("meteor_spawner")

func _process(delta):
	if is_paused:
		return  # Don't spawn meteors while paused
	
	game_time += delta
	time_since_last_spawn += delta
	
	# Gradually increase difficulty
	if current_spawn_interval > min_spawn_interval:
		current_spawn_interval -= interval_decrease_rate * delta
		current_spawn_interval = max(current_spawn_interval, min_spawn_interval)
	
	if current_meteor_speed < max_meteor_speed:
		current_meteor_speed += speed_increase_rate * delta
		current_meteor_speed = min(current_meteor_speed, max_meteor_speed)
	
	# Spawn meteor when interval is reached
	if time_since_last_spawn >= current_spawn_interval:
		spawn_meteor()
		time_since_last_spawn = 0.0

func spawn_meteor():
	if meteor_scene == null:
		print("Error: Meteor scene not assigned!")
		return
	
	# Create a new meteor instance
	var meteor = meteor_scene.instantiate()
	
	# Set random X position across the full screen width (0 to 1920)
	var random_x = randf_range(0, spawn_width)
	meteor.position = Vector2(random_x, -50)
	# Set the meteor's fall speed
	meteor.fall_speed = current_meteor_speed
	
	# Add meteor as child of this spawner
	add_child(meteor)
	
	print("Spawned meteor at X: ", random_x)  # Debug print

func reset_difficulty():
	# Reset to initial difficulty settings
	current_spawn_interval = initial_spawn_interval
	current_meteor_speed = initial_meteor_speed
	time_since_last_spawn = 0.0
	game_time = 0.0
	is_paused = false
	
	# Clear all existing meteors
	for child in get_children():
		if child is Area2D or child.has_method("_on_body_entered"):
			child.queue_free()

func pause_spawning():
	is_paused = true
	# Freeze all existing meteors
	for child in get_children():
		if child is Area2D:
			child.set_process(false)

func resume_spawning():
	is_paused = false
	# Unfreeze all existing meteors
	for child in get_children():
		if child is Area2D:
			child.set_process(true)
