extends VBoxContainer

@onready var name_label = $NameLabel

func update_infos(building:Building2D):
	name_label.text = building.name
