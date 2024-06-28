extends Node

var storage = {}

@onready var game:Game2D = get_parent()
@onready var event_bus = $"../EventBus"

# produced type, [needed ticks, needed workers]
enum Recipes{needed_ticks, needed_workers}
var recipes = {
	Resources.Types.Wood : [1, 4]
}

enum Production_Line{current_workers, production_rate, current_ticks}
var production_lines = {}

var workers := 0:
	set(value):
		workers = value
		event_bus.available_workers_updated.emit(game.population - workers)

enum Waiting_Lines{resource_type, needed_workers}
var waiting_lines = []

func _ready():
	event_bus.population_updated.connect(_on_EventBus_population_updated)

func create_or_update_line(resource_type:Resources.Types, workers_amount:int):
	if production_lines.has(resource_type):
		var line = production_lines[resource_type]
	
		line[Production_Line.current_workers] += workers_amount
	
		line[Production_Line.production_rate] = int(line[Production_Line.current_workers] / recipes[resource_type][Recipes.needed_workers])
	
		event_bus.resource_prodution_rate_updated.emit(resource_type, line[Production_Line.production_rate])
	else:
		var needed_workers = recipes[resource_type][Recipes.needed_workers]
	
		var production_rate:int = 0
	
		if (workers_amount >= needed_workers):
			production_rate = workers_amount / needed_workers
	
		production_lines[resource_type] = [workers_amount, production_rate, 0]
	
		event_bus.resource_prodution_rate_updated.emit(resource_type, production_rate)

func add_workers(resource_type:Resources.Types, workers_amount:int):
	workers += workers_amount
	
	if (game.population - workers) < 0:
		waiting_lines.push_back([resource_type, workers_amount])
	else:
		create_or_update_line(resource_type, workers_amount)

func _on_EventBus_population_updated(population_amount):
	var population_pool = population_amount
	
	var i := 0
	
	while i < waiting_lines.size():
		if waiting_lines[i][Waiting_Lines.needed_workers] <= population_pool:
			var waiting_line = waiting_lines.pop_at(i)
			
			var waiting_line_needed_workers = waiting_line[Waiting_Lines.needed_workers]
			
			create_or_update_line(waiting_line[Waiting_Lines.resource_type],
				waiting_line_needed_workers)
				
			population_pool -= waiting_line_needed_workers
			
			if population_pool == 0:
				break
		else:
			i += 1

func _on_TheTicker_timeout():
	for resource_type in production_lines:
		var line = production_lines[resource_type]
		
		line[Production_Line.current_ticks] += 1
		
		if line[Production_Line.current_ticks] >= \
			recipes[resource_type][Recipes.needed_ticks]:
			
			line[Production_Line.current_ticks] = 0
			
			if storage.has(resource_type):
				storage[resource_type] += line[Production_Line.production_rate]
			else:
				storage[resource_type] = line[Production_Line.production_rate]
			
			event_bus.resource_updated.emit(resource_type, storage[resource_type])
		
	pass # Replace with function body.
