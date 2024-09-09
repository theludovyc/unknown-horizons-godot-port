extends Control

const confirm_menu = "Go back to Main Menu ?"
const confirm_restart = "Restart the Game ?"
const confirm_quit = "Quit the Game ?"

@onready var confirm_dialog = %ConfirmDialog
@onready var resume_button = %ResumeButton

func _process(_delta):
	if visible and Input.is_action_just_pressed("ui_cancel"):
		_on_resume_button_pressed()

func _ready():
	if OS.has_feature("web"):
		%ExitButton.hide()

	set_process(false)

func _on_resume_button_pressed():
	hide()
	set_process(false)
	get_tree().paused = false

func _on_restart_button_pressed():
	confirm_dialog.popup_confirm(confirm_restart, _on_confirm_restart_confirmed)

func _on_main_menu_button_pressed():
	confirm_dialog.popup_confirm(confirm_menu, _on_confirm_main_menu_confirmed)

func _on_exit_button_pressed():
	confirm_dialog.popup_confirm(confirm_quit, _on_confirm_exit_confirmed)

func _on_confirm_restart_confirmed():
	hide()
	SceneLoader.change_scene(get_tree().current_scene.scene_file_path)

func _on_confirm_main_menu_confirmed():
	hide()
	SceneLoader.change_scene(RGT_Globals.main_menu_setting)

func _on_confirm_exit_confirmed():
	get_tree().quit()
