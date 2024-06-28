extends GridContainer

var event_bus:EventBus

@onready var bot_menu := $"../.."

@onready var tooltip := $"../../../Tooltip"

# Called when the node enters the scene tree for the first time.
func _ready():
	var root_node = get_tree().current_scene
	
	if (root_node.has_node("EventBus")):
		event_bus = root_node.get_node("EventBus")
		
		event_bus.building_created.connect(_on_building_event.unbind(1))
		event_bus.building_creation_aborted.connect(_on_building_event.unbind(1))
		
		for child in get_children():
			child.pressed.connect(_on_building_button_pressed.bind(child.building_type))
			child.mouse_entered.connect(_on_building_button_mouse_entered.bind(child.building_type))
			child.mouse_exited.connect(_on_building_button_mouse_exited)

func _on_building_button_pressed(building_type:Buildings.Types):
	if (event_bus):
		event_bus.create_building.emit(building_type)
	bot_menu.visible = false

func _on_building_event():
	bot_menu.visible = true
	
func _on_building_button_mouse_entered(building_type:Buildings.Types):
	tooltip.set_building_info(building_type)
	tooltip.visible = true
	
func _on_building_button_mouse_exited():
	tooltip.visible = false
