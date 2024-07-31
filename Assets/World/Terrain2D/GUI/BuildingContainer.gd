extends VBoxContainer

@onready var name_label = $NameLabel

@onready var building_info_container = $BuildingInfoContainer

func update_infos(building:Building2D):
	name_label.text = Buildings.get_building_name(building.building_id)
	
	building_info_container.update_infos(building.building_id)
