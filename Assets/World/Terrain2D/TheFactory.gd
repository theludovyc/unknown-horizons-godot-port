extends Node

var storage = {}

@onready var event_bus = $"../EventBus"

# Type, NeedTicks, CurrentTicks, ProductionRate
var production_lines = [
	[Game2D.Resources_Types.Wood, 1, 0, 1]
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_TheTicker_timeout():
	for line in production_lines:
		line[2] += 1
		
		if line[2] >= line[1]:
			line[2] = 0
			
			if storage.has(line[0]):
				storage[line[0]] += line[3]
			else:
				storage[line[0]] = line[3]
			
			event_bus.resource_updated.emit(line[0], storage[line[0]])
		
	pass # Replace with function body.
