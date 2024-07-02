extends PanelContainer

@onready var label_amount := $HBoxContainer/PanelContainer/HBoxContainer/LabelAmount

# Called when the node enters the scene tree for the first time.
func _ready():
	var current_node = get_tree().current_scene
	
	if current_node.has_node("EventBus"):
		var event_bus = current_node.get_node("EventBus")
		
		event_bus.connect("money_updated", _on_EventBus_money_updated)

func _on_EventBus_money_updated(amount):
	label_amount.text = str(amount)
