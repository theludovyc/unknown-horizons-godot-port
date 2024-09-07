extends SpinBox

@onready var line_edit = get_line_edit()

# Called when the node enters the scene tree for the first time.
func _ready():
	line_edit.context_menu_enabled = false
	line_edit.gui_input.connect(_on_gui_input)

	pass # Replace with function body.

func _on_gui_input(event:InputEvent):
	if event is InputEventKey and event.pressed and \
	(event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER):
		line_edit.release_focus()
		line_edit.accept_event()
