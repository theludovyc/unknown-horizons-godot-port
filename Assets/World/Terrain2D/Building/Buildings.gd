extends Object
class_name Buildings

enum Types{
	Warehouse,
	Residential,
	Producing
}

enum Ids{
	Warehouse,
	Tent,
	Lumberjack
}

enum Datas{
	name,
	type,
	cost,
	produce,
	max_workers
}

const datas = {
	Ids.Warehouse:{
		Datas.name:&"Warehouse",
		Datas.type:Types.Warehouse
	},
	Ids.Tent:{
		Datas.name:&"Tent",
		Datas.type:Types.Residential,
		Datas.cost:[
			[Resources.Types.Wood, 1], [Resources.Types.Textile, 1]
		],
		Datas.max_workers:4
	},
	Ids.Lumberjack:{
		Datas.name:&"Lumberjack",
		Datas.type:Types.Producing,
		Datas.cost:[
			[Resources.Types.Wood, 1], [Resources.Types.Textile, 1]
		],
		Datas.produce:Resources.Types.Wood,
		Datas.max_workers:4
	}
}

# warning: conflict with get_name
static func get_building_name(building_id:Buildings.Ids) -> StringName:
	if not datas.has(building_id):
		return StringName()
		
	return datas[building_id][Datas.name]

static func get_building_cost(building_id:Buildings.Ids) -> Array:
	if not datas.has(building_id):
		return []
		
	var building_datas = datas[building_id]
	
	if not building_datas.has(Datas.cost):
		return []
		
	return building_datas[Datas.cost]
