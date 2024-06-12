extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	var current_node = get_tree().current_scene
	
	if current_node.has_node("EventBus"):
		current_node.get_node("EventBus").connect("workers_updated", _on_EventBus_workers_updated)
	
	pass # Replace with function body.

func _on_EventBus_workers_updated(workers_amount):
	var sign = "+" if workers_amount >= 0 else "-"
	text = "(" + sign + str(workers_amount) + ")"
