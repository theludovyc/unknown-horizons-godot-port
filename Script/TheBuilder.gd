extends Node

@onready var node_buildings:Node = %Buildings

func get_buildings_save() -> Dictionary:
	var datas:Array
	
	for child:Building2D in node_buildings.get_children():
		datas.append([child.building_id, child.position])
	
	return {"Buildings":datas}
