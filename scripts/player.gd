extends MoveableTile2D

class_name Player

@onready var movement_direction = null
@onready var facing_direction = movement_direction
@onready var grabbed_object = null

@onready var animatedSprite2D = $AnimatedSprite2D
@onready var golem = $"../Golem"

func _process(_delta):
	# ADD ANIMATIONS FOR MOVEMENT
	# ADD SOUNDS FOR MOVEMENT
	if Input.is_action_just_pressed("player_right"):
		movement_direction = "right"
	elif Input.is_action_just_pressed("player_down"):
		movement_direction = "down"
	elif Input.is_action_just_pressed("player_left"):
		movement_direction = "left"
	elif Input.is_action_just_pressed("player_up"):
		movement_direction = "up"
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
		
		print("Facing: ", facing_direction, " Moving Direction:", movement_direction)
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
			else:
				push(movement_direction)
				
		else:
			push(movement_direction)

		facing_direction = movement_direction
	super._process(_delta)
