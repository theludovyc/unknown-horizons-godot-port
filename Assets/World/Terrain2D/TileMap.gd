extends TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = FileAccess.open("res://Assets/World/Terrain2D/mp_dev.json", FileAccess.READ)
	
	if file == null:
		push_error("Error: can't open file")
		return
	
	var json = JSON.new()
	
	if json.parse(file.get_as_text()) != OK:
		push_error("Error: can't parse json")
		return
	
	for island in json.data["islands"]:
		var deep_cells:PackedVector2Array
		var shallow_cells:PackedVector2Array
		var sand_cells:PackedVector2Array
		var ground_cells:PackedVector2Array
			
		var set_cells = func(array_in, atlas_pos, array_out):
			for i in range(0, array_in.size(), 2):
				var tile_vec = Vector2i(array_in[i], array_in[i + 1])
				array_out.push_back(tile_vec)
				set_cell(0, tile_vec, 1, atlas_pos)
				
		set_cells.call(island["deep_tiles"], Vector2i(1, 2), deep_cells)
		set_cells.call(island["shallow_tiles"], Vector2i(4, 2), shallow_cells)
		set_cells.call(island["sand_tiles"], Vector2i(7, 2), sand_cells)
		set_cells.call(island["ground_tiles"], Vector2i(7, 6), ground_cells)
	
		set_cells_terrain_connect(0, ground_cells, 0, 3)
		set_cells_terrain_connect(0, sand_cells, 0, 2)
		set_cells_terrain_connect(0, shallow_cells, 0, 1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
