extends Area2D

@onready var animatedSprite = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	add_to_group("inactive_tiles")
	animatedSprite.play("inactive")
	self.hide()

func _on_body_entered(body):
	if body in get_tree().get_nodes_in_group("pushable"):
		print("New node added to win...")
		add_to_group("activated_tiles")
		remove_from_group("inactive_tiles")
		animatedSprite.play("activated")
	for node in get_tree().get_nodes_in_group("activated_tiles"):
		print("Activated: ", node)
	if get_tree().get_nodes_in_group("inactive_tiles").is_empty():
		print("You won!!!")

func _on_body_exited(body):
	if body in get_tree().get_nodes_in_group("pushable"):
		remove_from_group("activated_tiles")
		add_to_group("inactive_tiles")
		animatedSprite.play("inactive")
	for node in get_tree().get_nodes_in_group("inactive_tiles"):
		print("Inactive: ", node)

func _process(delta):
	if Input.is_action_just_pressed("show_win_tiles"):
		if self.visible == false:
			self.show()
		else:
			self.hide()
