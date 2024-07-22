extends Object
class_name Resources

enum Types{
	Wood,
	Textile
}

const Icons = {
	Types.Wood:preload("res://Assets/UI/Icons/Resources/32/008.png"),
	Types.Textile:preload("res://Assets/UI/Icons/Resources/32/003.png")
}

enum LevelTypes{
	Gathered,
	TransformedOnce,
	TransformedTwice
}

const Levels = {
	Types.Wood:LevelTypes.Gathered,
	Types.Textile:LevelTypes.TransformedTwice
}
