extends MainMenu

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_anything_pressed():
		# Set the animation mark to the very end, so all final values are still set.
		var animation_player := $AnimationPlayer as AnimationPlayer
		animation_player.seek(animation_player.current_animation_length)

		set_process(false)
