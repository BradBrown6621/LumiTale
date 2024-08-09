extends Node2D
class_name Pawn

enum CellType { ACTOR, OBSTACLE, OBJECT }

@export var type: CellType = CellType.ACTOR

var active: bool = true:
	set(value):
		active = value
		set_process(value)
		set_process_input(value)
