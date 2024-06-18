extends Node
class_name Game2D

enum Resources_Types{
	Wood
}

@onready var rtl := $CanvasLayer/RichTextLabel

@onready var tm := %TileMap

@onready var cam := $Camera2D

@onready var node_entities := %Entities

@onready var event_bus := $EventBus

@onready var the_factory := $TheFactory

# if not null follow the cursor
var cursor_entity : Building2D
# avoid create building on first clic
var cursor_entity_wait_release : bool = false

var population := 0 :
	set(value):
		population = value
		event_bus.population_updated.emit(value)
		
var workers := 0 :
	set(value):
		workers = value
		event_bus.workers_updated.emit(value)

const Entities_Scene = {
	Entities.types.Warehouse:preload("res://Assets/World/Terrain2D/Building/Warehouse.tscn"),
	Entities.types.Residential:preload("res://Assets/World/Terrain2D/Building/Residential.tscn"),
	Entities.types.Lumberjack:preload("res://Assets/World/Terrain2D/Building/Lumberjack.tscn"),
	Entities.types.Spruce:preload("res://Assets/World/Terrain2D/Trees/Spruce.tscn")
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
	
	#spawn entity
	if (cursor_entity):
		cursor_entity.position = tm.map_to_local(tile_pos)
		
		if cursor_entity_wait_release and Input.is_action_just_released("alt_command"):
			cursor_entity_wait_release = false
		
		if not cursor_entity_wait_release and Input.is_action_just_pressed("alt_command"):
			match(cursor_entity.entity_type):
				Entities.types.Residential:
					population += 5
					workers += 5
					
				Entities.types.Lumberjack:
					the_factory.add_workers(Resources_Types.Wood, 2)
			
			event_bus.building_created.emit(cursor_entity.entity_type)
			cursor_entity = null
		
		if cursor_entity and Input.is_action_just_pressed("main_command"):
			event_bus.building_creation_aborted.emit(cursor_entity.entity_type)
			cursor_entity.call_deferred("queue_free")
			cursor_entity = null

func instantiate_Entity(entity_type:Entities.types) -> Node2D:
	var entity_instance = Entities_Scene[entity_type].instantiate()
	
	node_entities.add_child(entity_instance)
	
	if entity_instance is Building2D:
		entity_instance.selected.connect(_on_building_selected)
	
	return entity_instance

func _on_building_selected(entity_type:Entities.types):
	prints(name, entity_type)
	pass


func _on_EventBus_create_building(building_type):
	var entity := instantiate_Entity(building_type)
	cursor_entity = entity
	cursor_entity_wait_release = true
	pass # Replace with function body.
