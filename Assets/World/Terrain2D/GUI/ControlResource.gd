extends PanelContainer

@export var resource_type : Game2D.Resources_Types

@onready var label_amount := $HBoxContainer/PanelContainer/HBoxContainer/LabelAmount
@onready var label_production_rate := $HBoxContainer/PanelContainer/HBoxContainer/LabelProductionRate

# Called when the node enters the scene tree for the first time.
func _ready():
	var current_node = get_tree().current_scene
	
	if current_node.has_node("EventBus"):
		current_node.get_node("EventBus").connect("resource_updated", _on_EventBus_resource_updated)

func _on_EventBus_resource_updated(type, amount):
	if type == resource_type:
		label_amount.text = str(amount)
