@tool

extends Sprite2D
class_name EntityStatic

@export var width = 1:
	set(p_width):
		if p_width != width:
			width = p_width
			update_offset()

@export var height = 1:
	set(p_height):
		if p_height != height:
			height = p_height
			update_offset()

func _ready():
	if Engine.is_editor_hint():
		texture_changed.connect(_on_texture_changed)
	
func update_offset():
	if texture == null:
		return
	
	if centered:
		centered = false
	
	offset = Vector2(0, -texture.get_height()) + Vector2(-width * 32, height * 16)
	
func _on_texture_changed():
	update_offset()
