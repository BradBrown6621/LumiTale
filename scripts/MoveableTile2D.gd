extends CharacterBody2D
class_name MoveableTile2D

@onready var currentPos = self.position
@onready var newPos = currentPos
@onready var isMoving = true

var SPEED = 4
var TILESIZE = 16

func move(direction):
	if isMoving == false and not getObject(direction) is TileMap:
		if direction == "right":
			newPos[0] += TILESIZE
			isMoving = true

		elif direction == "down":
			newPos[1] += TILESIZE
			isMoving = true

		elif direction == "left":
			newPos[0] += -TILESIZE
			isMoving = true

		elif direction == "up":
			newPos[1] += -TILESIZE
			isMoving = true

func getObject(facing):
	var raycast = RayCast2D.new()
	if facing == "right":
		raycast.target_position = Vector2i(9, 0)
	elif facing == "down":
		raycast.target_position = Vector2i(0, 9)
	elif facing == "left":
		raycast.target_position = Vector2i(-9, 0)
	elif facing == "up":
		raycast.target_position = Vector2i(0, -9)
	
	add_child(raycast)
	raycast.enabled = true
	
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		return raycast.get_collider()
	return null

func push(push_direction):
	var objectFacing = getObject(push_direction)
	if objectFacing is TileMap:
		return -1
	elif objectFacing is CharacterBody2D:
		if (objectFacing.push(push_direction) != -1):
			move(push_direction)
			return 0
		else:
			return -1
	else:
		move(push_direction)
		return 0

func _process(_delta):
	if currentPos != newPos:
		if currentPos.x < newPos.x:
			currentPos.x += SPEED
		elif currentPos.x > newPos.x:
			currentPos.x -= SPEED
		elif currentPos.x == newPos.x:
			currentPos.x = newPos.x

		if currentPos.y < newPos.y:
			currentPos.y += SPEED
		elif currentPos.y > newPos.y:
			currentPos.y -= SPEED
		elif currentPos.y == newPos.y:
			currentPos.y = newPos.y

	if currentPos == newPos:
		isMoving = false

	self.position = Vector2(currentPos.x, currentPos.y)
