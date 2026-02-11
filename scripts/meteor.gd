extends Area2D

@export var fall_speed = 200.0
@export var damage = 1

func _ready():
	# Connect the body_entered signal to detect collision with player
	body_entered.connect(_on_body_entered)

func _process(delta):
	# Move the meteor downward
	position.y += fall_speed * delta
	
	# Delete meteor if it goes off screen (below)
	if position.y > 1200:  # Updated for 1080 height + buffer
		queue_free()

func _on_body_entered(body):
	# If meteor hits the player
	if body.name == "Player" and body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()  # Delete the meteor
