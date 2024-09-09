@tool

extends EntityStatic
class_name Building2D

signal selected(type)

@export var building_id: Buildings.Ids

var event_bus: EventBus

var is_selected := false


func build():
	var current_scene = get_tree().current_scene
	if current_scene.has_node("EventBus"):
		event_bus = current_scene.get_node("EventBus")
		event_bus.send_building_selected.connect(_on_building_selected)
	var area2d := $Area2D
	area2d.input_event.connect(_on_Area2d_input_event)
	area2d.mouse_entered.connect(_on_Area2d_mouse_entered)
	area2d.mouse_exited.connect(_on_Area2d_mouse_exited)


func _on_Area2d_input_event(viewport, event, shape_idx):
	if not is_selected and event.is_action_pressed("alt_command"):
		is_selected = true
		modulate = Color.YELLOW
		if event_bus != null:
			event_bus.send_building_selected.emit(self)


func _on_Area2d_mouse_entered():
	if not is_selected:
		modulate = Color.YELLOW


func _on_Area2d_mouse_exited():
	if not is_selected:
		modulate = Color.WHITE


func _on_building_selected(building_node: Building2D):
	if is_selected and building_node != self:
		is_selected = false
		modulate = Color.WHITE


func select():
	is_selected = true
	modulate = Color.YELLOW


func deselect():
	is_selected = false
	modulate = Color.WHITE
