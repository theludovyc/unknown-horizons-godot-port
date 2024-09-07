extends Control

@onready var version_number_label = %VersionNumber

@onready var confirmation_dialog = %ConfirmationDialog

# Called when the node enters the scene tree for the first time.
func _ready():
	version_number_label.text = "v" + ProjectSettings.get_setting("application/config/version", "0.0")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_anything_pressed():
		# Set the animation mark to the very end, so all final values are still set.
		var animation_player := $AnimationPlayer as AnimationPlayer
		animation_player.seek(animation_player.current_animation_length)

		set_process(false)

func _on_SinglePlayerButton_pressed():
	SceneLoader.change_scene(RGT_Globals.first_game_scene_setting)
	pass # Replace with function body.

func _on_QuitButton_pressed():
	confirmation_dialog.popup_centered()

func _on_ConfirmationDialog_confirmed():
	get_tree().quit()
