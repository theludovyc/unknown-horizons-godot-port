extends VBoxContainer

var resource_order_scene = preload("res://Assets/World/Terrain2D/GUI/ResourceOrder.tscn")

@onready var resource_popup = %ResourcePopup

@onready var order_container = %OrderContainer

var is_new_order := false

var current_resource_order:Node = null

func _ready():
	resource_popup.result.connect(_on_ResourcePopup_result)

func _on_ResourcePopup_result(resource_type:Resources.Types):
	if is_new_order:
		var resource_order = resource_order_scene.instantiate()
		
		order_container.add_child(resource_order)
		
		resource_order._resource_type = resource_type
		resource_order._resource_button.pressed.connect(
			_on_OrderResourceButton_pressed.bind(resource_order))
		
		is_new_order = false
	elif current_resource_order != null:
		current_resource_order._resource_type = resource_type

func _on_OrderResourceButton_pressed(node:Control):
	current_resource_order = node
	
	resource_popup.popup_centered()

func _on_NewOrderButton_pressed():
	is_new_order = true
	
	resource_popup.popup_centered()
