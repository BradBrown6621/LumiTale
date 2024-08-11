extends Sprite2D
class_name Golem

@onready var tile_map = $"../TileMap"
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ray_cast_2d = $RayCast2D
@onready var pushable_sprites = get_tree().get_nodes_in_group("pushable")

var is_moving = false
var direction = "down"
var is_pulling = false
var pulled_object: Sprite2D = null
var pull_direction: Vector2
var ignore_raycast: bool = false
var golemActivate = true

func _physics_process(delta):
	if global_position == animated_sprite_2d.global_position:
		is_moving = false
		animated_sprite_2d.play("idle_" + direction)
		return
	
	animated_sprite_2d.play("walk_" + direction)
	animated_sprite_2d.global_position = animated_sprite_2d.global_position.move_toward(global_position, 1)

func _process(delta):
	if Input.is_action_just_pressed("golemActivate"):
		parseGolemCommands("npepseep")

func parseGolemCommands(command: String):
	
	# North, East, South West = n, e, s, w
	for char in command:
		var move_direction = Vector2.ZERO
		print("Attempting move (", char, ")...")
		if is_moving:
			print("Cannot move; already in motion")
			await get_tree().create_timer(1).timeout
			is_moving = false

		if char == "e":
			move_direction.x += 1
			if !is_pulling:
				direction = "right"
		elif char == "w":
			move_direction.x -= 1
			if !is_pulling:
				direction = "left"
		elif char == "s":
			move_direction.y += 1
			if !is_pulling:
				direction = "down"
		elif char == "n":
			move_direction.y -= 1
			if !is_pulling:
				direction = "up"
		elif char == "p":
			toggle_pull()
		
		if move_direction != Vector2.ZERO:
			move(move_direction)

	self.golemActivate = false

func move(move_direction: Vector2):
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	var target_tile: Vector2i = current_tile + Vector2i(move_direction)
	
	print("Current tile: ", current_tile)
	print("Direction: ", self.direction)
	
	ray_cast_2d.target_position = move_direction * 16
	ray_cast_2d.force_raycast_update()
	
	if not is_pulling:
		for pushable in pushable_sprites:
			pushable.check_push(global_position, move_direction)
	
	if ray_cast_2d.is_colliding():
		toggle_pull()
		return
	
	if is_pulling and pulled_object:
		#pull_direction = move_direction  # Update pull direction
		var pull_target = tile_map.map_to_local(tile_map.local_to_map(pulled_object.global_position) + Vector2i(move_direction))
		if move_direction == -pull_direction:
			ignore_raycast = true
			pulled_object.move_to(pull_target, ignore_raycast)
		else:
			ignore_raycast= false
			pulled_object.move_to(pull_target, ignore_raycast)
		
	is_moving = true
	global_position = tile_map.map_to_local(target_tile)
	animated_sprite_2d.global_position = tile_map.map_to_local(current_tile)
	# If pulled_object and player are not adjacent toggle_pull
	if is_pulling:
		var dx = abs(pulled_object.global_position.x - global_position.x)
		var dy = abs(pulled_object.global_position.y - global_position.y)
		prints("dx:", dx)
		prints("dy:", dy)
		if (dx >= 16 && dy >= 16):
			print("object no longer adjacent")
			toggle_pull()
	

func toggle_pull():
	if is_pulling:
		is_pulling = false
		print("not pulling")
		pulled_object = null
		pull_direction = Vector2.ZERO
	else:
		var direction_vector = get_direction_vector()
		var facing_tile = tile_map.local_to_map(global_position) + Vector2i(direction_vector)
		for pushable in pushable_sprites:
			if tile_map.local_to_map(pushable.global_position) == facing_tile:
				is_pulling = true
				print("pulling")
				pulled_object = pushable
				pull_direction = direction_vector
				break

func get_direction_vector() -> Vector2:
	match direction:
		"right":
			return Vector2.RIGHT
		"left":
			return Vector2.LEFT
		"down":
			return Vector2.DOWN
		"up":
			return Vector2.UP
	return Vector2.ZERO
