extends CharacterBody2D

# Movement variables
@export var speed = 300.0
@export var jump_velocity = -400.0
@export var gravity = 980.0

# Health system
@export var max_health = 2
var current_health = max_health
var is_invincible = false
@export var invincibility_time = 1.0  # Time you're invincible after getting hit

# Sprite references
@onready var sprite = $Sprite2D
@export var sprite_right: Texture2D  # Assign "robot zijkant rechts.png" in Inspector
@export var sprite_left: Texture2D   # Assign "robot zijkant links.png" in Inspector

func _ready():
	current_health = max_health
	add_to_group("player")

func _physics_process(delta):
	# Add gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# Get input direction
	var direction = Input.get_axis("move_left", "move_right")
	
	# Apply movement
	if direction:
		velocity.x = direction * speed
		
		# Change sprite based on direction
		if direction > 0 and sprite_right:  # Moving right
			sprite.texture = sprite_right
		elif direction < 0 and sprite_left:  # Moving left
			sprite.texture = sprite_left
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	# Move the character
	move_and_slide()
	
	# Blink effect when invincible
	if is_invincible:
		sprite.modulate.a = 0.5 if int(Time.get_ticks_msec() / 100) % 2 == 0 else 1.0
	else:
		sprite.modulate.a = 1.0

func take_damage(amount: int):
	if is_invincible:
		return  # Can't take damage while invincible
	
	current_health -= amount
	print("Health: ", current_health, "/", max_health)
	
	if current_health <= 0:
		die()
	else:
		# Become invincible temporarily
		is_invincible = true
		await get_tree().create_timer(invincibility_time).timeout
		is_invincible = false

func die():
	print("Player died!")
	
	# Notify game manager
	var game_manager = get_node_or_null("/root/Main/GameManager")
	if game_manager and game_manager.has_method("on_player_death"):
		game_manager.on_player_death()
	else:
		# Fallback if no game manager
		await get_tree().create_timer(2.0).timeout
		get_tree().reload_current_scene()
