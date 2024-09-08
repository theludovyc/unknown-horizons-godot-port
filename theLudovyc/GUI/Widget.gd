extends Control

@onready var buttons = [$BuildMenuButton, $MarketMenuButton]


func disable_buttons(b: bool):
	for button in buttons:
		button.disabled = b
