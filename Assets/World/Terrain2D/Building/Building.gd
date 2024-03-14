extends EntityStatic
class_name Building2D

signal selected(type)

@export var entity_type:Entities.types

func _on_Area2d_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("alt_command"):
		selected.emit(entity_type)
