extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	var current_node = get_tree().current_scene
	
	if current_node.has_node("EventBus"):
		current_node.get_node("EventBus").connect("available_workers_updated", _on_EventBus_available_workers_updated_updated)
	
	pass # Replace with function body.

func _on_EventBus_available_workers_updated_updated(available_workers_amount):
	var sign = "+" if available_workers_amount >= 0 else ""
	text = "(" + sign + str(available_workers_amount) + ")"
