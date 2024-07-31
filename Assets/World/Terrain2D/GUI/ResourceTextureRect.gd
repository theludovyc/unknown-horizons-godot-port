extends TextureRect

@export var resource_type:Resources.Types:
	set(value):
		resource_type = value
		
		texture = Resources.get_resource_icon(resource_type)
