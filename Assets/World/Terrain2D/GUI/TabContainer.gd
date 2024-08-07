extends TabContainer

enum WidgetMenus {
	Market,
	Build,
	Building
}

@onready var bottom_container = %BottomContainer

@onready var tooltip := %WidgetTooltip

@onready var building_container := $BuildingContainer

var event_bus:EventBus

# Called when the node enters the scene tree for the first time.
func _ready():
	var current_scene = get_tree().current_scene
	
	if current_scene.has_node("EventBus"):
		event_bus = current_scene.get_node("EventBus")
		
		event_bus.send_building_selected.connect(_on_receive_building_selected)
	
	pass # Replace with function body.

func on_MenuButton_pressed(menu:WidgetMenus):
	if current_tab != menu:
		current_tab = menu
		
		bottom_container.set_menu_visibility(true)
		return
	
	bottom_container.invert_menu_visibility()

func _on_BuildMenuButton_pressed():
	on_MenuButton_pressed(WidgetMenus.Build)
	
	if tooltip.visible:
		tooltip.visible = false

func _on_MarketMenuButton_pressed():
	on_MenuButton_pressed(WidgetMenus.Market)
	
	if bottom_container.visible:
		tooltip.visible = true
		
		tooltip.set_money_production_rate_info()
	else:
		tooltip.visible = false
	
func _on_receive_building_selected(building:Building2D):
	bottom_container.set_menu_visibility(true)
	
	if Buildings.get_building_type(building.building_id) == Buildings.Types.Warehouse:
		if current_tab != WidgetMenus.Market:
			current_tab = WidgetMenus.Market
		
		if tooltip.visible == false:
			tooltip.visible = true
			tooltip.set_money_production_rate_info()
			
		return
	
	if current_tab != WidgetMenus.Building:
		current_tab = WidgetMenus.Building
		
	if tooltip.visible:
		tooltip.visible = false
		
	building_container.update_infos(building)
