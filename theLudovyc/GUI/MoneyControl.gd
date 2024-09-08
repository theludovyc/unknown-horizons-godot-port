extends PanelContainer

@onready var label_amount := $HBoxContainer/PanelContainer/HBoxContainer/LabelAmount
@onready var label_production_rate := $HBoxContainer/PanelContainer/HBoxContainer/LabelProductionRate


# Called when the node$".", $HBoxContainer/PanelContainer/HBoxContainer/LabelProductionRate enters the scene tree for the first time.
func _ready():
	var current_node = get_tree().current_scene

	if current_node.has_node("EventBus"):
		var event_bus = current_node.get_node("EventBus")

		event_bus.connect("money_updated", _on_EventBus_money_updated)
		event_bus.connect(
			"money_production_rate_updated", _on_EventBus_money_production_rate_updated
		)

	$TextureButton.get_node("TextureRect").texture = TheBank.money_icon


func _on_EventBus_money_updated(amount):
	label_amount.text = str(amount)


func _on_EventBus_money_production_rate_updated(production_rate):
	label_production_rate.text = "(" + Helper.get_string_from_signed_int(production_rate) + ")"
