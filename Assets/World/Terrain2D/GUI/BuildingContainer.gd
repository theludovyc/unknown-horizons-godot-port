extends VBoxContainer

@onready var name_label = $NameLabel

func update_infos(building:Building2D):
	name_label.text = Buildings.get_building_name(building.building_id)
