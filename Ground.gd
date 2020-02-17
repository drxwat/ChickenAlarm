extends TileMap


func get_under_cells(right_position: Vector2, left_position: Vector2) -> Array:
	var right_cell = world_to_map(right_position + Vector2(0, cell_size.y / 2))
	var left_cell = world_to_map(left_position + Vector2(0, cell_size.y / 2))
	
	var cells = []
	for i in range(right_cell.x - left_cell.x):
		cells.append(Vector2(right_cell.x - i, right_cell.y))
	
	return cells


func get_direction_cells(direction: Vector2, center: Vector2, size: float) -> Array:
	var cells = []
	
	var horizontal = abs(direction.x) == 1
	
	# calculating half of the cell bias
	var half_adj = Vector2(cell_size.x / 2, 0) if horizontal else Vector2(0, cell_size.y / 2)
	half_adj = half_adj if direction.x > 0 or direction.y > 0 else - half_adj
	
	# calculating top(horizontal) or left corner(vertical)
	var size_adj = Vector2(0, -size/2) if horizontal else Vector2(-size/2, 0)
	var corener = world_to_map(center + size_adj + half_adj)

	if horizontal:
		for i in range((size / cell_size.y) + 1):
			cells.append(Vector2(corener.x, corener.y + i))
	else: 
		for i in range((size / cell_size.x) + 1):
			cells.append(Vector2(corener.x + i, corener.y))
	return cells


func replace_cells(cells: Array, tile: int):
	for cell in cells:
		set_cellv(cell, tile)


func remove_cells(cells: Array):
	replace_cells(cells, -1)


func remove_first_active_cell(cells: Array) -> bool:
	for cell in cells:
		var tile = get_cellv(cell)
		if tile != TileMap.INVALID_CELL:
			set_cellv(cell, -1)
			return true
	return false


