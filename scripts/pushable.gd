extends Sprite2D

@onready var tile_map = $"../TileMap"
@onready var sprite_2d = $AnimatedSprite2D
@onready var ray_cast = $RayCast2D

var is_moving = false
var direction = "down"

func _physics_process(delta):
	if global_position == sprite_2d.global_position:
		is_moving = false
		sprite_2d.play("idle_" + direction)
		return
	
	sprite_2d.play("walk_" + direction)
	sprite_2d.global_position = sprite_2d.global_position.move_toward(global_position, 1)

func check_push(player_position: Vector2, player_direction: Vector2):
	var my_tile = tile_map.local_to_map(global_position)
	var tile_size = tile_map.tile_set.tile_size
	var player_target_pos = player_position + player_direction * Vector2(tile_size)
	var player_target_tile = tile_map.local_to_map(player_target_pos)
	
	if my_tile == player_target_tile:
		move(player_direction)

func move(direction: Vector2):
	# Get current tile Vector2i
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	# Get target tile Vector2i
	var target_tile: Vector2i = Vector2i(
		current_tile.x + round(direction.x),
		current_tile.y + round(direction.y)
	)
	ray_cast.target_position = direction * 16
	ray_cast.force_raycast_update()

	if ray_cast.is_colliding():
		return
	
	# Move the sprite
	is_moving = true
	global_position = tile_map.map_to_local(target_tile)
	
	sprite_2d.global_position = tile_map.map_to_local(current_tile)
	
	# Update direction based on movement
	if direction.x > 0:
		self.direction = "right"
	elif direction.x < 0:
		self.direction = "left"
	elif direction.y > 0:
		self.direction = "down"
	elif direction.y < 0:
		self.direction = "up"
