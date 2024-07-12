extends HBoxContainer

@onready var _resource_button = $VBoxContainer/TextureButton

var _resource_type:Resources.Types:
	set(value):
		_resource_type = value
		
		if is_instance_valid(_resource_button):
			_resource_button.set_resource_icon(_resource_type)
