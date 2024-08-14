extends MoveableTile2D

@onready var animationSprite = $AnimatedSprite2D

func _process(delta):
	if self.face == "right":
		self.animationSprite.play("idle_right")
	elif self.face == "down":
		self.animationSprite.play("idle_down")
	elif self.face == "left":
		self.animationSprite.play("idle_left")
	elif self.face == "up":
		self.animationSprite.play("idle_up")

	super._process(delta)
