extends TileMap

@onready var game:Game2D = get_tree().current_scene

var map_size:Vector2i

var minimap:PackedByteArray

enum Minimap_Cell_Type{Deep, Shallow, Sand, Ground, Tree, Building}

func minimap_set_cell(x:int, y:int, type:Minimap_Cell_Type):
	minimap[y * map_size.x + x] = type

func minimap_set_cell_vec(vec:Vector2i, type:Minimap_Cell_Type):
	minimap_set_cell(vec.x, vec.y, type)

func minimap_get_cell(vec:Vector2i) -> Minimap_Cell_Type:
	if vec.x < 0 or vec.y < 0 or vec.x >= map_size.x or vec.y >= map_size.y:
		return Minimap_Cell_Type.Deep
	
	return minimap[vec.y * map_size.x + vec.x]
	
func minimap_get_pos(index:int) -> Vector2i:
	return Vector2i(index % map_size.x, index / map_size.x)
	
func is_constructible(tile_pos:Vector2i) -> int:
	match minimap_get_cell(tile_pos):
		Minimap_Cell_Type.Ground:
			return 1
		Minimap_Cell_Type.Tree:
			return 2
	return 0

func entityStatic_get_top_left_tile(entity:EntityStatic, tile_center:Vector2i) -> Vector2i:
	return Vector2i(tile_center.x, tile_center.y - entity.height / 2)

# 0 or >0 == OK
# -1 == KO
# >0 numbers of trees
func is_entityStatic_constructible(entity:EntityStatic, tile_center:Vector2i) -> int:
	var top_left_tile = entityStatic_get_top_left_tile(entity, tile_center)
	
	var trees = 0
	
	for x in entity.width:
		for y in entity.height:
			match is_constructible(top_left_tile + Vector2i(x, y)):
				2:
					trees += 1
				0:
					return -1
					
	return trees

func build_entityStatic(entity:EntityStatic, tile_center:Vector2i):
	var top_left_tile = entityStatic_get_top_left_tile(entity, tile_center)
	
	for x in entity.width:
		for y in entity.height:
			var tile_coord = top_left_tile + Vector2i(x, y)
			
			if minimap_get_cell(tile_coord) == Minimap_Cell_Type.Tree:
				erase_cell(1, tile_coord)
			
			minimap_set_cell_vec(tile_coord, Minimap_Cell_Type.Building)

func demolish_building(building:Building2D):
	var top_left_tile = entityStatic_get_top_left_tile(building,
		local_to_map(building.position))

	for x in building.width:
		for y in building.height:
			var tile_coord = top_left_tile + Vector2i(x, y)
			
			minimap_set_cell_vec(tile_coord, Minimap_Cell_Type.Ground)

func create_island(map_file:String) -> int:
	var file = FileAccess.open(map_file, FileAccess.READ)
	
	if file == null:
		push_error("Error: can't open file")
		return FAILED
	
	var json = JSON.new()
	
	if json.parse(file.get_as_text()) != OK:
		push_error("Error: can't parse json")
		return FAILED
	
	var set_cells = func(array_in, atlas_pos, array_out, type:Minimap_Cell_Type):
		for i in range(0, array_in.size(), 2):
			var tile_vec = Vector2i(array_in[i], array_in[i + 1])
			
			minimap_set_cell_vec(tile_vec, type)
			
			array_out.push_back(tile_vec)
			
			set_cell(0, tile_vec, 1, atlas_pos)
	
	var deep_tiles:PackedVector2Array
	var shallow_tiles:PackedVector2Array
	var sand_tiles:PackedVector2Array
	var ground_tiles:PackedVector2Array
	
	var json_map_size = json.data["size"]
	
	map_size = Vector2i(json_map_size[0], json_map_size[1])
	
	minimap.resize(map_size.x * map_size.y)
	
	set_cells.call(json.data["deep_tiles"], Vector2i(1, 2),
		deep_tiles, Minimap_Cell_Type.Deep)
	set_cells.call(json.data["shallow_tiles"], Vector2i(4, 2),
		shallow_tiles, Minimap_Cell_Type.Shallow)
	set_cells.call(json.data["sand_tiles"], Vector2i(7, 2),
		sand_tiles, Minimap_Cell_Type.Sand)
	set_cells.call(json.data["ground_tiles"], Vector2i(7, 6),
		ground_tiles, Minimap_Cell_Type.Ground)

	set_cells_terrain_connect(0, ground_tiles, 0, 3)
	set_cells_terrain_connect(0, sand_tiles, 0, 2)
	set_cells_terrain_connect(0, shallow_tiles, 0, 1)
	
	# spawn trees
	var noise := FastNoiseLite.new()
	noise.frequency = 0.3
	
	for i in range(minimap.size()):
		if minimap[i] == Minimap_Cell_Type.Ground:
			var pos = minimap_get_pos(i)
			
			if noise.get_noise_2dv(pos) > 0.1:
				set_cell(1, pos, 2, Vector2.ZERO)
			
				minimap[i] = Minimap_Cell_Type.Tree
	
	return OK

func get_pos_limits() -> PackedVector2Array:
	var used_rect = get_used_rect()
	
	var pre_array:PackedVector2Array = [
		map_to_local(used_rect.position),
		map_to_local(used_rect.position + Vector2i(used_rect.size.x, 0)),
		map_to_local(used_rect.position + Vector2i(0, used_rect.size.y)),
		map_to_local(used_rect.position + Vector2i(used_rect.size.x, used_rect.size.y))
	]
	
	var return_array:PackedVector2Array = [
		pre_array[0], pre_array[1]
	]
	
	for vec in pre_array:
		if vec.x < return_array[0].x:
			return_array[0].x = vec.x
			
		if vec.y < return_array[0].y:
			return_array[0].y = vec.y
			
		if vec.x > return_array[1].x:
			return_array[1].x = vec.x
			
		if vec.y > return_array[1].y:
			return_array[1].y = vec.y
	
	return return_array

func local_to_map_to_local(position:Vector2) -> Vector2:
	return map_to_local(local_to_map(position))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
