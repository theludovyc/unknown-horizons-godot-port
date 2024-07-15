extends Node
class_name TheBank

const money_icon = preload("res://Assets/UI/Icons/Resources/32/001.png")

@onready var event_bus := $"../EventBus"

var money := 0 :
	set(value):
		money = value
		event_bus.money_updated.emit(value)

func try_to_buy_resource(resource_type:Resources.Types, amount:int) -> bool:
	if amount == 0 or not Resources.Levels.has(resource_type):
		return true
	
	var cost:int = (Resources.Levels[resource_type] + 1) * amount
	
	if money >= cost:
		money -= cost
		return true
		
	return false
