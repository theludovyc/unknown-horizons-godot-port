extends VBoxContainer

@onready var resource_in = $GridContainer/ResourceIn

@onready var resource_out = $GridContainer/ResourceOut

@onready var ticks_label = $HBoxContainer/TicksContainer/ValueLabel

@onready var workers_label = $HBoxContainer/WorkerContainer/ValueLabel

func update_infos(building_id:Buildings.Ids):
	var resource_type = Buildings.get_produce_resource(building_id)
	
	resource_in.resource_type = Recipes.get_recipe_input(resource_type)
	
	resource_out.resource_type = resource_type

	ticks_label.text = str(Recipes.get_recipe_needed_ticks(resource_type))
	
	workers_label.text = str(Buildings.get_max_workers(building_id))

