extends Node
class_name TheStorage

var storage = {}

@onready var event_bus = $"../EventBus"

func add_resource(resource_type:Resources.Types, amount:int):
	if sign(amount) < 0 and abs(amount) > storage[resource_type]:
		push_error(name, "Error: cannot consume " + str(amount) + " of " + str(resource_type))
		
		storage[resource_type] = 0
	else:
		if storage.has(resource_type):
			storage[resource_type] += amount
		else:
			storage[resource_type] = amount
		
	event_bus.resource_updated.emit(resource_type, storage[resource_type])
	
	if storage[resource_type] == 0:
		storage.erase(resource_type)
