extends Pawn

@export var combat_actor: PackedScene
#@export var move_speed: float = 100
@onready var animated_sprite = $AnimatedSprite2D
@onready var parent = get_parent()

var direction = "down"
var lost = false

func _ready():
	update_direction(Vector2.RIGHT)

func _process(delta):
	var input_direction = get_input_direction()
	if not input_direction:
		animated_sprite.play("idle_" + direction)
		return
	
	update_direction(input_direction)
	update_direction(input_direction)
	
	var target_position = parent.request_move(self, input_direction)
	if target_position:
		move_to(target_position)
	#else:
	#	bump()

func get_input_direction():
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)

func update_direction(input_direction):
	if input_direction.y < 0:
		direction = "up"
	elif input_direction.y > 0:
		direction = "down"
	elif input_direction.x < 0:
		direction = "left"
	elif input_direction.x > 0:
		direction = "right"

func move_to(target_position):
	set_process(false)
	animated_sprite.play("walk_" + direction)
	
	var move_direction = (target_position - position).normalized()
	
	var tween = create_tween()
	tween.tween_property(self, "position", target_position, 1.0)
	
	await tween.finished
	animated_sprite.play("idle_" + direction)
	set_process(true)

#func bump():
#	animated_sprite.play("bump")
#	await animated_sprite.animation_finished
#	animated_sprite.play("idle_" + direction)
