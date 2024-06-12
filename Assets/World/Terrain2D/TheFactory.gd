extends Node

var storage = {}

# Type, NeedTicks, CurrentTicks, ProductionRate
var production_lines = [
	[Game2D.Resources_Types.Wood, 2, 0, 2]
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_TheTicker_timeout():
	for line in production_lines:
		line[2] += 1
		
		if line[2] >= line[1]:
			line[2] = 0
			
			storage[line[0]] += line[3]
		
	pass # Replace with function body.
