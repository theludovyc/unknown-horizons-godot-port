extends VBoxContainer

@onready var name_label = $NameLabel

@onready var building_info_container = $BuildingInfoContainer

func update_infos(building:Building2D):
	var building_id = building.building_id
	
	name_label.text = Buildings.get_building_name(building_id)
	
	building_info_container.update_infos(building_id)
