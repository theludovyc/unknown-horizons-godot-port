extends TabContainer

@onready var building_producing_container = $BuildingProducingContainer

enum Tabs{
	Producing
}

func update_infos(building_id:Buildings.Ids):
	match(Buildings.get_building_type(building_id)):
		Buildings.Types.Producing:
			visible = true
			
			current_tab = Tabs.Producing
			
			building_producing_container.update_infos(building_id)
		
		_: visible = false
