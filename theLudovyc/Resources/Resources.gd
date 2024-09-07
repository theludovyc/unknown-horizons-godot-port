extends Object
class_name Resources

enum Types{
	Wood,
	Textile
}

const Icons = {
	Types.Wood:preload("res://Art/Image/Gui/Icons/Resources/32/008.png"),
	Types.Textile:preload("res://Art/Image/Gui/Icons/Resources/32/003.png")
}

static func get_resource_icon(resource_type:Types) -> Texture2D:
	return Icons.get(resource_type)

enum LevelTypes{
	Gathered,
	TransformedOnce,
	TransformedTwice
}

const Levels = {
	Types.Wood:LevelTypes.Gathered,
	Types.Textile:LevelTypes.TransformedTwice
}
