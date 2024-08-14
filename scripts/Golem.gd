extends MoveableTile2D
class_name Golem

@onready var movement_direction = null
@onready var grabbed_object = null
@onready var facing_direction = movement_direction

func activate(inputs=""):
	if inputs != "":
		for input in inputs:
			await get_tree().create_timer(1).timeout
			if input == "r":
				movement_direction = "right"
			elif input == "d":
				movement_direction = "down"
			elif input == "l":
				movement_direction = "left"
			elif input == "u":
				movement_direction = "up"
			else:
				movement_direction = null
			
			print(input)

			if movement_direction != null:
				push(movement_direction)
			facing_direction = movement_direction
