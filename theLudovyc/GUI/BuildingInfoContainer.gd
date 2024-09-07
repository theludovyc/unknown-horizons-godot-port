extends TabContainer

@onready var building_residential_container = $BuildingResidentialContainer

@onready var building_producing_container = $BuildingProducingContainer

enum Tabs{
	Residential,
	Producing
}

func show_building_info_tab(tab_id:Tabs, building_id:Buildings.Ids):
	visible = true
	
	current_tab = tab_id
	
	get_child(tab_id).update_infos(building_id)

func update_infos(building_id:Buildings.Ids):
	match(Buildings.get_building_type(building_id)):
		Buildings.Types.Residential:
			show_building_info_tab(Tabs.Residential, building_id)
		
		Buildings.Types.Producing:
			show_building_info_tab(Tabs.Producing, building_id)
		
		_: visible = false
