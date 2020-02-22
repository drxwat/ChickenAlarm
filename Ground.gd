extends TileMap


func remove_cell(cell: Vector2) -> bool:
	var tile = get_cellv(cell)
	if tile != TileMap.INVALID_CELL:
		set_cellv(cell, -1)
		return true
	return false


func get_direction_cell(direction: Vector2, border: Vector2) -> Vector2:
	var horizontal = abs(direction.x) == 1
	
	# calculating half of the cell bias
	var half_adj = Vector2(cell_size.x / 2, 0) if horizontal else Vector2(0, cell_size.y / 2)
	half_adj = half_adj if direction.x > 0 or direction.y > 0 else - half_adj
	
	return world_to_map(border + half_adj)
