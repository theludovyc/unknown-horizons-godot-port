extends VBoxContainer

@onready var resource_in = $GridContainer/ResourceIn

@onready var resource_out = $GridContainer/ResourceOut2

@onready var workers_label = $HBoxContainer/WorkerContainer/ValueLabel

func update_infos(building_id:Buildings.Ids):
	resource_out.resource_type = Buildings.get_produce_resource(building_id)
	
	workers_label.text = str(Buildings.get_max_workers(building_id))
