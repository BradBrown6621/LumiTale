extends MoveableTile2D

class_name Player

@onready var movement_direction = "down"
@onready var facing_direction = movement_direction
@onready var grabbed_object = null

@onready var animatedSprite2D = $AnimatedSprite2D
@onready var golem = $"../Golem"
@onready var golemProgramMode = false
@onready var golemProgramArray = []

func _process(_delta):
	# ADD SOUNDS FOR MOVEMENT
	if not golemProgramMode:
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
		elif Input.is_action_just_pressed("player_grabbed_object_rotate"):
			if grabbed_object:
				grabbed_object.rotateClockwise()
		elif Input.is_action_just_pressed("player_golem_program"):
				golemProgramMode = true
				movement_direction = null
		elif Input.is_action_just_pressed("player_golem_activate"):
			golem.activate(golemProgramArray)
			golemProgramArray = []
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
		super._process(_delta)
	else:
		if Input.is_action_just_pressed("player_golem_program"):
			golemProgramMode = false
		else:
			var actions = InputMap.get_actions()
			for action_name in actions:
				if Input.is_action_just_pressed(action_name):
					golemProgramArray.append(action_name)
				else:
					action_name = null
