extends VBoxContainer

@onready var name_label = $HBoxContainer/NameLabel

@onready var building_info_container = $BuildingInfoContainer

@onready var event_bus:EventBus

@onready var confirmation_dialog := %ConfirmationDialog

const confirmation_text = "Are you sure you want to demolish this building?"

func _ready():
	event_bus = get_tree().current_scene.get_node_or_null("EventBus")

func update_infos(building:Building2D):
	var building_id = building.building_id
	
	name_label.text = Buildings.get_building_name(building_id)
	
	building_info_container.update_infos(building_id)

func _on_DeleteButton_pressed():
	confirmation_dialog.canceled.connect(_on_ConfirmationDialog_canceled)
	confirmation_dialog.confirmed.connect(_on_ConfirmationDialog_confirmed)
	confirmation_dialog.dialog_text = confirmation_text
	confirmation_dialog.popup_centered()
	
func _on_ConfirmationDialog_canceled():
	confirmation_dialog.canceled.disconnect(_on_ConfirmationDialog_canceled)
	confirmation_dialog.confirmed.disconnect(_on_ConfirmationDialog_confirmed)
	
func _on_ConfirmationDialog_confirmed():
	confirmation_dialog.canceled.disconnect(_on_ConfirmationDialog_canceled)
	confirmation_dialog.confirmed.disconnect(_on_ConfirmationDialog_confirmed)
	
	if event_bus != null:
		event_bus.ask_demolish_current_building.emit()
