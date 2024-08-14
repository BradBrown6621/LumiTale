extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	add_to_group("inactive_tiles")

func _on_body_entered(body):
	print(body)
	if body in get_tree().get_nodes_in_group("pushable"):
		print("New node added to win...")
		add_to_group("activated_tiles")
		remove_from_group("inactive_tiles")
	for node in get_tree().get_nodes_in_group("activated_tiles"):
		print("Activated: ", node)
	if get_tree().get_nodes_in_group("inactive_tiles").is_empty():
		print("You won!!!")

func _on_body_exited(body):
	remove_from_group("activated_tiles")
	add_to_group("inactive_tiles")
	for node in get_tree().get_nodes_in_group("inactive_tiles"):
		print("Inactive: ", node)
