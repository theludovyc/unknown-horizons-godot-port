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
	
	var deep_tiles:PackedVector2Array
	var shallow_tiles:PackedVector2Array
	var sand_tiles:PackedVector2Array
	var ground_tiles:PackedVector2Array
	
	set_cells.call(json.data["deep_tiles"], Vector2i(1, 2), deep_tiles)
	set_cells.call(json.data["shallow_tiles"], Vector2i(4, 2), shallow_tiles)
	set_cells.call(json.data["sand_tiles"], Vector2i(7, 2), sand_tiles)
	set_cells.call(json.data["ground_tiles"], Vector2i(7, 6), ground_tiles)

	set_cells_terrain_connect(0, ground_tiles, 0, 3)
	set_cells_terrain_connect(0, sand_tiles, 0, 2)
	set_cells_terrain_connect(0, shallow_tiles, 0, 1)
	
	var ground_tiles_constructible := ground_tiles.duplicate()
	
	# spawn the warehouse
	var entity := game.instantiate_Entity(Entities.types.Warehouse)
	entity.position = map_to_local(Vector2i(1, 20))
	
	# remove the constructible tiles of the warehouse
	for pos in [Vector2i(3, 21), Vector2i(3, 22)]:
		var find_pos := ground_tiles_constructible.find(pos)
		
		if find_pos != -1:
			ground_tiles_constructible.remove_at(find_pos)
	
	# spawn trees
	# create array of index with size of constructible tiles
	# and shuffle it
	var indexes = range(ground_tiles_constructible.size())
	indexes.shuffle()

	var tree_pos:PackedVector2Array
	
	var surrounded_pos:PackedVector2Array = [
		Vector2i(-1, 0),
		Vector2i(-1, 1),
		Vector2i(0, 1),
		Vector2i(1, 1),
		Vector2i(1, 0),
		Vector2i(1, -1),
		Vector2i(0, -1),
		Vector2i(-1, -1)
	]
	
	var get_surrounded_trees = func(vec:Vector2i):
		var sum := 0
		for pos:Vector2i in surrounded_pos:
			if tree_pos.has(vec + pos):
				sum += 1
		return sum
	
	# unstack the array of index and get ground tile pos
	for index in indexes:
		var tile_pos := ground_tiles_constructible[index]
		
		# 20% chance of spawn + 10% for each tile arround if is a tree (max 100%)
		var spawn_chance:float = (2. + get_surrounded_trees.call(tile_pos)) / 10.
	
		if spawn_chance == 1. or randf() < spawn_chance:
			#entity = game.instantiate_Entity(Entities.types.Spruce)
	#
			#entity.position = map_to_local(tile_pos)
	#
			#tree_pos.push_back(tile_pos)
			set_cell(1, tile_pos, 2, Vector2.ZERO)
	
	return OK

func local_to_map_to_local(position:Vector2) -> Vector2:
	return map_to_local(local_to_map(position))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
