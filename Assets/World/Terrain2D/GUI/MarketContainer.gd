extends VBoxContainer

var resource_order_scene = preload("res://Assets/World/Terrain2D/GUI/ResourceOrder.tscn")

@onready var resource_popup = %ResourcePopup

@onready var order_container = %OrderContainer

func _ready():
	resource_popup.result.connect(_on_ResourcePopup_result)

func _on_ResourcePopup_result(resource_type:Resources.Types):
	var resource_order = resource_order_scene.instantiate()
	
	order_container.add_child(resource_order)
	
	resource_order._resource_type = resource_type

func _on_NewOrderButton_pressed():
	resource_popup.popup_centered()
