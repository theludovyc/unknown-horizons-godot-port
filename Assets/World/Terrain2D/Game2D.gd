extends Node
class_name Game2D

@onready var rtl := $CanvasLayer/RichTextLabel

@onready var tm := %TileMap

@onready var cam := $Camera2D

@onready var node_entities := %Entities

@onready var event_bus := $EventBus

@onready var the_factory := $TheFactory

const Buildings_Scenes = {
	Buildings.Types.Warehouse:preload("res://Assets/World/Terrain2D/Building/Warehouse.tscn"),
	Buildings.Types.Residential:preload("res://Assets/World/Terrain2D/Building/Residential.tscn"),
	Buildings.Types.Lumberjack:preload("res://Assets/World/Terrain2D/Building/Lumberjack.tscn")
}

# if not null follow the cursor
var cursor_entity : Building2D
# avoid create building on first clic
var cursor_entity_wait_release : bool = false

var population := 0 :
	set(value):
		population = value
		event_bus.population_updated.emit(value)
		event_bus.available_workers_updated.emit(population - the_factory.workers)

# Called when the node enters the scene tree for the first time.
func _ready():
	tm.create_island("res://Assets/World/Terrain2D/singularity_40.json")
	
	the_factory.add_resource_to_storage(Resources.Types.Wood, 2)
	the_factory.add_resource_to_storage(Resources.Types.Textile, 16)
	
	pass # Replace with function body.

func has_resources_to_construct_building(building_type:Buildings.Types) -> bool:
	if not Buildings.Costs.has(building_type):
		return true
		
	var resources_costs = Buildings.Costs[building_type]
		
	for cost in resources_costs:
		if cost[1] > the_factory.storage.get(cost[0], 0):
			return false
			
	return true

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
		
		rtl.text += str(tm.is_constructible(tile_pos)) + "\n"
		
		rtl.text += str(tm.get_cell_atlas_coords(0, tile_pos))
	
	#spawn entity
	if (cursor_entity):
		cursor_entity.position = tm.map_to_local(tile_pos)
		
		var building_type = cursor_entity.building_type
		
		var trees = tm.is_entityStatic_constructible(cursor_entity, tile_pos)
		
		var is_constructible := false
		
		if has_resources_to_construct_building(building_type):
			if trees > 0:
				cursor_entity.modulate = Color(Color.ORANGE, 0.6)
			else:
				cursor_entity.modulate = Color(Color.GREEN, 0.6)
				
			is_constructible = true
		else:
			cursor_entity.modulate = Color(Color.RED, 0.6)
		
		if cursor_entity_wait_release and Input.is_action_just_released("alt_command"):
			cursor_entity_wait_release = false
		
		if not cursor_entity_wait_release \
		and is_constructible \
		and Input.is_action_just_pressed("alt_command"):
			match(building_type):
				Buildings.Types.Residential:
					population += 4
					
				Buildings.Types.Lumberjack:
					the_factory.add_workers(Resources.Types.Wood, 4)
			
			if Buildings.Costs.has(building_type):
				var resources_costs = Buildings.Costs[building_type]
		
				for cost in resources_costs:
					the_factory.add_resource_to_storage(cost[0], - cost[1])
			
			event_bus.building_created.emit(building_type)
			
			tm.build_entityStatic(cursor_entity, tile_pos)
			
			cursor_entity.modulate = Color.WHITE
			cursor_entity = null
		
		if cursor_entity and Input.is_action_just_pressed("main_command"):
			event_bus.building_creation_aborted.emit(building_type)
			cursor_entity.call_deferred("queue_free")
			cursor_entity = null

func instantiate_building(building_type:Buildings.Types) -> Building2D:
	var instance = Buildings_Scenes[building_type].instantiate() as Building2D
	
	prints(name, instance)
	
	node_entities.add_child(instance)
	
	#instance.selected.connect(_on_building_selected)
	
	return instance

func _on_building_selected(building_type:Buildings.Types):
	prints(name, building_type)
	pass

func _on_EventBus_create_building(building_type:Buildings.Types):
	var entity := instantiate_building(building_type)
	cursor_entity = entity
	cursor_entity_wait_release = true
	cursor_entity.modulate = Color(Color.RED, 0.6)
