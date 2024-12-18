extends TabContainer

enum WidgetMenus { Market, Build, Building }

@onready var bottom_container = %BottomContainer

@onready var tooltip := %WidgetTooltip

@onready var building_container := $BuildingContainer

var event_bus: EventBus


# Called when the node enters the scene tree for the first time.
func _ready():
	event_bus = get_tree().current_scene.get_node_or_null("EventBus")

	if event_bus != null:
		event_bus.send_building_selected.connect(_on_receive_building_selected)
		event_bus.send_current_building_demolished.connect(_on_receive_current_building_demolished)

	pass  # Replace with function body.


func on_MenuButton_pressed(menu: WidgetMenus):
	if current_tab != menu:
		if current_tab == WidgetMenus.Building or current_tab == WidgetMenus.Market:
			event_bus.ask_deselect_building.emit()

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
		if event_bus != null:
			event_bus.ask_select_warehouse.emit()

		tooltip.visible = true

		tooltip.set_money_production_rate_info()
	else:
		if event_bus != null:
			event_bus.ask_deselect_building.emit()

		tooltip.visible = false


func _on_receive_building_selected(building: Building2D):
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


func _on_receive_current_building_demolished():
	if current_tab == WidgetMenus.Building:
		bottom_container.set_menu_visibility(false)
