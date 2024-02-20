extends Node

@onready var rtl = $RichTextLabel

@onready var tm = $TileMap

@onready var cam = $Camera2D

enum EntityStatics {
	ClayDeposit
}

const EntityStatics_Datas = {
	EntityStatics.ClayDeposit:preload("res://Assets/World/Terrain2D/Resources/Clay/Clay.tscn")
}

# Called when the node enters the scene tree for the first time.
func _ready():
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

func instantiate_EntityStatics(entity:EntityStatics, tile_pos:Vector2i) -> bool:
	prints(name, tile_pos)
	
	var tile_data = tm.get_cell_tile_data(0, tile_pos)
	
	if !tm.is_constructible(tile_data):
		return false
	
	var entity_data = EntityStatics_Datas[entity]["data"]
	
	
	
	var entity_instance = EntityStatics_Datas[entity]["scene"].instantiate()
	entity_instance.position = tm.map_to_local(tile_pos)
	add_child(entity_instance)
	
	return true
