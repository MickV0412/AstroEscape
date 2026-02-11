extends CharacterBody2D

# Movement variables
@export var speed = 300.0
@export var jump_velocity = -400.0
@export var gravity = 980.0

# Sprite references
@onready var sprite = $Sprite2D
@export var sprite_right: Texture2D  # Assign "robot zijkant rechts.png" in Inspector
@export var sprite_left: Texture2D   # Assign "robot zijkant links.png" in Inspector

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
