extends CharacterBody2D

@export var move_speed : float = 100
@onready var animated_sprite = $AnimatedSprite2D

# Set initial direction var
var direction = "down"

func _physics_process(_delta):
	# Get input direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
		)
	# Update direction based on input
	update_direction(input_direction)
	
	# Update velocity
	velocity = input_direction * move_speed
	move_and_slide()	
	
	# Play the appropriate animation
	play_animation(input_direction)

func update_direction(input_direction):
	if input_direction.y < 0:
		direction = "up"
	elif input_direction.y > 0:
		direction = "down"
	elif input_direction.x < 0:
		direction = "left"
	elif input_direction.x > 0:
		direction = "right"
		
func play_animation(input_direction):
	# Check if player is moving
	if input_direction.length() > 0:
		match direction:
			"up":
				animated_sprite.play("walk_up")
			"down":
				animated_sprite.play("walk_down")
			"left":
				animated_sprite.play("walk_left")
			"right":
				animated_sprite.play("walk_right")
	else:
		animated_sprite.play("idle_" + direction)
