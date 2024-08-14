extends MoveableTile2D

class_name Golem

@onready var movement_direction = "down"
@onready var facing_direction = movement_direction
@onready var grabbed_object = null

@onready var animatedSprite2D = $AnimatedSprite2D

func activate(inputs=[]):
	# ADD SOUNDS FOR MOVEMENT
	for input in inputs:
		await get_tree().create_timer(1).timeout
		if input == "player_right":
			movement_direction = "right"
			animatedSprite2D.play("walk_right")
		elif input == "player_shift_right":
			facing_direction = "right"
			animatedSprite2D.play("idle_right")
		elif input == "player_down":
			movement_direction = "down"
			animatedSprite2D.play("walk_down")
		elif input == "player_shift_down":
			facing_direction = "down"
			animatedSprite2D.play("idle_down")
		elif input == "player_left":
			movement_direction = "left"
			animatedSprite2D.play("walk_left")
		elif input == "player_shift_left":
			facing_direction = "left"
			animatedSprite2D.play("idle_left")
		elif input == "player_up":
			movement_direction = "up"
			animatedSprite2D.play("walk_up")
		elif input == "player_shift_up":
			facing_direction = "up"
			animatedSprite2D.play("idle_up")
		elif input == "player_grab":
			if not grabbed_object:
				grabbed_object = getObject(facing_direction)
				print(grabbed_object)
				if not grabbed_object is CharacterBody2D:
					grabbed_object = null
				print("Grabbed object: ", grabbed_object)
			else:
				grabbed_object = null
		elif input == "player_grabbed_object_rotate":
			if grabbed_object:
				grabbed_object.rotateClockwise()
		else:
			movement_direction = null

		if movement_direction != null:
			
			var objectPlayerFacing = getObject(movement_direction) # Represented by @
			var objectGrabbedFacing
			var successfulPush = 0
			if grabbed_object != null:
				grabbed_object = grabbed_object
				objectGrabbedFacing = grabbed_object.getObject(movement_direction) # Represented by #

			# If in this configuration:
			# @# ->
			if objectPlayerFacing == grabbed_object:
				push(movement_direction)

			# If in this configuration:
			# #@ ->
			elif objectGrabbedFacing == self:
				successfulPush = grabbed_object.push(movement_direction)

			# Finally, if in this configuration (or any reflections):
			# #
			# @

			elif grabbed_object:
				push(movement_direction)
				successfulPush = grabbed_object.push(movement_direction)
			else:
				push(movement_direction)
			
			if successfulPush == -1:
				grabbed_object = null

			facing_direction = movement_direction
func _process(delta):
	super._process(delta)
