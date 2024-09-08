extends Object
class_name Recipes

# Needed 1 resource input, tick(s) and Worker(s) to produce 1 resource output
enum Datas { Input, Ticks, Workers }

const datas = {Resources.Types.Wood: {Datas.Input: -1, Datas.Ticks: 1, Datas.Workers: 4}}


static func get_recipe_input(resource_type: Resources.Types) -> int:
	if not datas.has(resource_type):
		return 0

	return datas[resource_type].get(Datas.Input)


static func get_recipe_needed_ticks(resource_type: Resources.Types) -> int:
	if not datas.has(resource_type):
		return 0

	return datas[resource_type].get(Datas.Ticks, 0)


static func get_recipe_needed_workers(resource_type: Resources.Types) -> int:
	if not datas.has(resource_type):
		return 0

	return datas[resource_type].get(Datas.Workers, 0)
