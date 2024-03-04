extends Node
class_name Game2D

@onready var rtl = $CanvasLayer/RichTextLabel

@onready var tm = $TileMap

@onready var cam = $Camera2D

@onready var node_entities = $Entities

enum Entities {
	Warehouse,
	Spruce
}

const Entities_Scene = {
	Entities.Warehouse:preload("res://Assets/World/Terrain2D/Building/Warehouse.tscn"),
	Entities.Spruce:preload("res://Assets/World/Terrain2D/Trees/Spruce.tscn")
}

# Called when the node enters the scene tree for the first time.
func _ready():
	tm.create_island("res://Assets/World/Terrain2D/singularity_40.json")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mousePos = get_viewport().get_mouse_position() + cam.position
	
	rtl.text = ""
	
	rtl.text += str(mousePos) + "\n"
	
	var tile_pos = tm.local_to_map(mousePos)
	
	rtl.text += str(tile_pos) + "\n"
	
	var tile_data = tm.get_cell_tile_data(0, tile_pos)
	
	if tile_data != null:
		rtl.text += str(tile_data.terrain_set) + " / " + str(tile_data.terrain) + "\n"
		
		rtl.text += str(tm.get_cell_atlas_coords(0, tile_pos))

func instantiate_Entity(entity:Entities) -> Node2D:
	var entity_instance = Entities_Scene[entity].instantiate()
	
	node_entities.add_child(entity_instance)
	
	return entity_instance
