extends Sprite2D

@onready var tile_map = $"../TileMap"
@onready var sprite_2d = $AnimatedSprite2D
@onready var ray_cast_2d = $RayCast2D
@onready var pushable_sprites = get_tree().get_nodes_in_group("pushable")

var is_moving = false
var direction = "down"

func _physics_process(delta):
	if global_position == sprite_2d.global_position:
		is_moving = false
		sprite_2d.play("idle_" + direction)
		return
	
	sprite_2d.play("walk_" + direction)
	sprite_2d.global_position = sprite_2d.global_position.move_toward(global_position, 1)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_moving:
		return
		
	if Input.is_action_pressed("right"):
		direction = "right"
		move(Vector2.RIGHT)
	elif Input.is_action_pressed("left"):
		direction = "left"
		move(Vector2.LEFT)
	elif Input.is_action_pressed("down"):
		direction = "down"
		move(Vector2.DOWN)
	elif Input.is_action_pressed("up"):
		direction = "up"
		move(Vector2.UP)

func move(direction: Vector2):
	# Get current tile Vector 2i
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	# Get target tile Vector 2i
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y
	)
	# Get custom data layer from target tile
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
		
	ray_cast_2d.target_position = direction * 16
	ray_cast_2d.force_raycast_update()
	# Check for pushable sprites
	for pushable in pushable_sprites:
		pushable.check_push(global_position, direction)
		print(pushable)
		
	if ray_cast_2d.is_colliding():
		return
	
	# Move player
	is_moving = true
	global_position = tile_map.map_to_local(target_tile)
	
	sprite_2d.global_position = tile_map.map_to_local(current_tile)
