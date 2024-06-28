extends Object
class_name Buildings

enum Types{
	Warehouse,
	Residential,
	Lumberjack
}

const Costs = {
	Types.Residential:[[Resources.Types.Wood, 1], [Resources.Types.Textile, 1]],
	Types.Lumberjack:[[Resources.Types.Wood, 1], [Resources.Types.Textile, 1]]
}
