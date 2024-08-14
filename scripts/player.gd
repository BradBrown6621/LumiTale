extends MoveableTile2D

class_name Player

@onready var movement_direction = "down"
@onready var facing_direction = movement_direction
@onready var grabbed_object = null

@onready var animatedSprite2D = $AnimatedSprite2D
@onready var golem = $"../Golem"

func _process(_delta):
	# ADD ANIMATIONS FOR MOVEMENT
	# ADD SOUNDS FOR MOVEMENT
	if Input.is_action_just_pressed("player_right", true):
		movement_direction = "right"
		animatedSprite2D.play("walk_right")
	elif Input.is_action_just_pressed("player_shift_right", true):
		facing_direction = "right"
		animatedSprite2D.play("idle_right")
	elif Input.is_action_just_pressed("player_down", true):
		movement_direction = "down"
		animatedSprite2D.play("walk_down")
	elif Input.is_action_just_pressed("player_shift_down", true):
		facing_direction = "down"
		animatedSprite2D.play("idle_down")
	elif Input.is_action_just_pressed("player_left", true):
		movement_direction = "left"
		animatedSprite2D.play("walk_left")
	elif Input.is_action_just_pressed("player_shift_left", true):
		facing_direction = "left"
		animatedSprite2D.play("idle_left")
	elif Input.is_action_just_pressed("player_up", true):
		movement_direction = "up"
		animatedSprite2D.play("walk_up")
	elif Input.is_action_just_pressed("player_shift_up", true):
		facing_direction = "up"
		animatedSprite2D.play("idle_up")
	elif Input.is_action_just_pressed("player_grab"):
		if not grabbed_object:
			grabbed_object = getObject(facing_direction)
			print(grabbed_object)
			if not grabbed_object is CharacterBody2D:
				grabbed_object = null
			print("Grabbed object: ", grabbed_object)
		else:
			grabbed_object = null
	elif Input.is_action_just_pressed("player_golem_activate"):
		golem.activate()
	else:
		movement_direction = null

	if movement_direction != null:
		
		var objectPlayerFacing = getObject(facing_direction)
		# Check if object attempting to push is not grabbed
		if objectPlayerFacing != null and objectPlayerFacing != grabbed_object:
		# Attempt to push object and move
			push(movement_direction)
		# Otherwise, attempt to push grabbed object
		elif grabbed_object:
			if (movement_direction == "up" and facing_direction == "down") or (movement_direction == "down" and facing_direction == "up") or (movement_direction == "right" and facing_direction == "left") or  (movement_direction == "left" and facing_direction == "right"):
				# If we need to pull a tile, we just initiate a push on that tile and move the tile being "pulled"
				grabbed_object.push(movement_direction)
			elif movement_direction == facing_direction:
				grabbed_object.push(movement_direction)
				push(movement_direction)
			else:
				push(movement_direction)
				grabbed_object.push(movement_direction)
				
		else:
			push(movement_direction)

		facing_direction = movement_direction
	super._process(_delta)
