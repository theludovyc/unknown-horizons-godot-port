extends Camera2D

const SPEED = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	position += dir * SPEED * delta
	
	pass
