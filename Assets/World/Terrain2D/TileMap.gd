extends TileMap

@onready var game:Game2D = get_parent()

func is_constructible_from_tile_data(tile_data:TileData) -> bool:
	return tile_data.get_custom_data("Constructible")
	
func is_constructible(tile_pos:Vector2i) -> bool:
	return get_cell_tile_data(0, tile_pos).get_custom_data("Constructible")
	
func is_entityStatic_constructible(entity:EntityStatic, tile_center:Vector2i) -> bool:
	var top_left_tile = tile_center - Vector2i(entity.width / 2, entity.height / 2)
	
	for x in entity.width:
		for y in entity.height:
			if not is_constructible(top_left_tile + Vector2i(x, y)):
				return false

	return true

func create_island(map_file:String) -> int:
	var file = FileAccess.open(map_file, FileAccess.READ)
	
	if file == null:
		push_error("Error: can't open file")
		return FAILED
	
	var json = JSON.new()
	
	if json.parse(file.get_as_text()) != OK:
		push_error("Error: can't parse json")
		return FAILED
	
	var set_cells = func(array_in, atlas_pos, array_out):
		for i in range(0, array_in.size(), 2):
			var tile_vec = Vector2i(array_in[i], array_in[i + 1])
			array_out.push_back(tile_vec)
			set_cell(0, tile_vec, 1, atlas_pos)
	
	for island in json.data["islands"]:
		var deep_cells:PackedVector2Array
		var shallow_cells:PackedVector2Array
		var sand_cells:PackedVector2Array
		var ground_cells:PackedVector2Array
		
		set_cells.call(island["deep_tiles"], Vector2i(1, 2), deep_cells)
		set_cells.call(island["shallow_tiles"], Vector2i(4, 2), shallow_cells)
		set_cells.call(island["sand_tiles"], Vector2i(7, 2), sand_cells)
		set_cells.call(island["ground_tiles"], Vector2i(7, 6), ground_cells)
	
		set_cells_terrain_connect(0, ground_cells, 0, 3)
		set_cells_terrain_connect(0, sand_cells, 0, 2)
		set_cells_terrain_connect(0, shallow_cells, 0, 1)
		
		var entity = game.instantiate_EntityStatic(game.EntityStatics.ClayDeposit)
		
		prints(is_entityStatic_constructible(entity, ground_cells[5]))
		
		entity.position = map_to_local(ground_cells[5])
	
	return OK


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
