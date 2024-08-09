extends TileMap

enum CellType { ACTOR, OBSTACLE, OBJECT }
# Assuming dialogue_ui is defined elsewhere or will be filled in later

func _ready():
	for child in get_children():
		var cell_position = local_to_map(to_local(child.global_position))
		set_cell(0, cell_position, 0, Vector2i(child.type, 0))

func get_cell_pawn(cell, type = CellType.ACTOR):
	for node in get_children():
		if node.type != type:
			continue
		if local_to_map(node.global_position) == cell:
			return node

func request_move(pawn, direction):
	var cell_start = local_to_map(to_local(pawn.global_position))
	var cell_target = Vector2i(cell_start.x + direction.x, cell_start.y + direction.y)
	var cell_tile_id = get_cell_source_id(0, cell_target)
	
	match cell_tile_id:
		-1:
			set_cell(0, cell_target, 0, Vector2i(CellType.ACTOR, 0))
			set_cell(0, cell_start, -1)
			return map_to_local(cell_target) + tile_set.tile_size / 2.0
		0:  # Assuming 0 is your source_id for all tiles
			var target_tile_type = get_cell_atlas_coords(0, cell_target).x
			if target_tile_type in [CellType.OBJECT, CellType.ACTOR]:
				var target_pawn = get_cell_pawn(cell_target, target_tile_type)
				print("Cell %s contains %s" % [cell_target, target_pawn.name])
				if not target_pawn.has_node("DialoguePlayer"):
					return
			# Assuming dialogue_ui is a valid NodePath leading to a UI element capable of showing dialogues
			# get_node(dialogue_ui).show_dialogue(pawn, target_pawn.get_node("DialoguePlayer"))
