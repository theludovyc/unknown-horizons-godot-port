extends TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = FileAccess.open("res://Assets/World/Terrain2D/mp_dev.csv", FileAccess.READ)
	
	var deep_cells:PackedVector2Array
	var shallow_cells:PackedVector2Array
	var sand_cells:PackedVector2Array
	var ground_cells:PackedVector2Array
	
	while(!file.eof_reached()):
		var line = file.get_csv_line()
		
		if line.is_empty() or line.size() < 3:
			continue
			
		var atlas_pos:Vector2i
		
		var tile_vec = Vector2i(int(line[0]), int(line[1]))
		
		match int(line[2]):
			2:
				atlas_pos = Vector2i(1, 2)
				deep_cells.push_back(tile_vec)
				
			3:
				atlas_pos = Vector2i(7, 6)
				ground_cells.push_back(tile_vec)
				
			4:
				atlas_pos = Vector2i(7, 2)
				sand_cells.push_back(tile_vec)
				
			_:
				atlas_pos = Vector2i(4, 2)
				shallow_cells.push_back(tile_vec)
	
		set_cell(0, tile_vec, 1, atlas_pos)
	
	set_cells_terrain_connect(0, ground_cells, 0, 3)
	
	set_cells_terrain_connect(0, sand_cells, 0, 2)
	
	set_cells_terrain_connect(0, shallow_cells, 0, 1)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
