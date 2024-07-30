@tool

extends EntityStatic
class_name Building2D

signal selected(type)

@export var building_type:Buildings.Types

var event_bus:EventBus

func _ready():
	if Engine.is_editor_hint():
		return
		
	var current_scene = get_tree().current_scene
	
	if current_scene.has_node("EventBus"):
		event_bus = current_scene.get_node("EventBus")

func _on_Area2d_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("alt_command"):
		if event_bus != null:
			event_bus.send_building_selected.emit(self)
