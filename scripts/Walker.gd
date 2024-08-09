extends Pawn

@export var combat_actor: PackedScene
@onready var animated_sprite = $AnimatedSprite2D

var direction = "down"
var lost = false
@onready var parent = get_parent()

func _ready():
	update_look_direction(Vector2.RIGHT)

func _process(_delta):
	var input_direction = get_input_direction()
	if not input_direction:
		return
	update_look_direction(input_direction)
	var target_position = parent.request_move(self, input_direction)
	if target_position:
		move_to(target_position)
	else:
		bump()

func get_input_direction():
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)

func update_look_direction(direction):
	$Pivot/Sprite2D.rotation = direction.angle()

func move_to(target_position):
	set_process(false)
	animated_sprite.play("walk_" + direction)
	var move_direction = (position - target_position).normalized()
	
	# Create a new Tween
	var tween = create_tween()
	tween.tween_property($Pivot, "position", Vector2.ZERO, animated_sprite.current_animation_length).from(move_direction * 32)
	
	$Pivot/Sprite2D.position = position - target_position
	position = target_position
	
	await animated_sprite.animation_finished
	set_process(true)

func bump():
	animated_sprite.play("bump")
