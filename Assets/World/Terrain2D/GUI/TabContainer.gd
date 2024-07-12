extends TabContainer

enum WidgetMenus {
	Market,
	Build
}

@onready var bot_menu = %BotMenu

@onready var tooltip := %WidgetTooltip

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func on_MenuButton_pressed(menu:WidgetMenus):
	if current_tab != menu:
		current_tab = menu
		
		bot_menu.set_menu_visibility(true)
		return
	
	bot_menu.invert_menu_visibility()

func _on_BuildMenuButton_pressed():
	on_MenuButton_pressed(WidgetMenus.Build)

func _on_MarketMenuButton_pressed():
	on_MenuButton_pressed(WidgetMenus.Market)
	
	if bot_menu.visible:
		tooltip.visible = true
		
		tooltip.set_money_production_rate_info()
	else:
		tooltip.visible = false
	
