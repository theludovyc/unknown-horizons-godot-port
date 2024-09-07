extends HBoxContainer

@onready var resident_label = $ValueLabel

func update_infos(building_id:Buildings.Ids):
	resident_label.text = Helper.get_string_from_signed_int(
		Buildings.get_max_workers(building_id))
