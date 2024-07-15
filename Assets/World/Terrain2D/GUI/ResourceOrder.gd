extends HBoxContainer

@onready var _resource_texture = $VBoxContainer/TextureRect

var _resource_type:Resources.Types:
	set(value):
		_resource_type = value
		
		if is_instance_valid(_resource_texture):
			if Resources.Icons.has(value):
				_resource_texture.texture = Resources.Icons[value]
