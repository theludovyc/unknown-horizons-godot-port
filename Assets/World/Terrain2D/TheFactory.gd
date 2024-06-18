extends Node

var storage = {}

@onready var event_bus = $"../EventBus"

# produced type, [needed ticks, needed workers]
enum Recipes{needed_ticks, needed_workers}
var recipes = {
	Game2D.Resources_Types.Wood : [1, 2]
}

enum Production_Line{resource_type, current_workers, production_rate, current_ticks}
var production_lines = []

func add_workers(resource_type:Game2D.Resources_Types, workers_amount:int):
	var needed_workers = recipes[resource_type][Recipes.needed_workers]
	
	var production_rate:int = 0
	
	if (workers_amount >= needed_workers):
		production_rate = workers_amount / recipes[resource_type][Recipes.needed_workers]
	
	production_lines.append([resource_type, workers_amount, production_rate, 0])
	
	event_bus.resource_prodution_rate_updated.emit(resource_type, production_rate)

func _on_TheTicker_timeout():
	for line in production_lines:
		line[Production_Line.current_ticks] += 1
		
		var resource_type = line[Production_Line.resource_type]
		
		if line[Production_Line.current_ticks] >= \
			recipes[resource_type][Recipes.needed_ticks]:
			
			line[Production_Line.current_ticks] = 0
			
			if storage.has(resource_type):
				storage[resource_type] += line[Production_Line.production_rate]
			else:
				storage[resource_type] = line[Production_Line.production_rate]
			
			event_bus.resource_updated.emit(resource_type, storage[resource_type])
		
	pass # Replace with function body.
