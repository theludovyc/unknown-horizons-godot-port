extends VBoxContainer

@onready var panel_container = %PanelContainer


func set_menu_visibility(b: bool):
	# avoid resize bug
	panel_container.visible = b
	visible = b


func invert_menu_visibility():
	# avoid resize bug
	panel_container.visible = !panel_container.visible
	visible = !visible
