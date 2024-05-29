extends TextureButton

var event_bus : EventBus

# Called when the node enters the scene tree for the first time.
func _ready():
	var root_node = get_tree().current_scene
	
	if (root_node.has_node("EventBus")):
		event_bus = root_node.get_node("EventBus")
		event_bus.building_created.connect(_on_building_event.unbind(1))
		event_bus.building_creation_aborted.connect(_on_building_event.unbind(1))
	
	pass # Replace with function body.

func _on_button_down():
	if (event_bus):
		event_bus.create_building.emit(Entities.types.Residential)
	disabled = true

func _on_building_event():
	if disabled:
		disabled = false
