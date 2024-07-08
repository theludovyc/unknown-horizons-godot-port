extends Camera2D

const SPEED = 500

const Edge_Limit = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	
	var viewport_rect = get_viewport_rect()
	
	var dir:Vector2
	
	if mouse_pos.x < Edge_Limit:
		dir.x = -1
		
	if mouse_pos.x > viewport_rect.size.x - Edge_Limit:
		dir.x = 1
	
	if mouse_pos.y < Edge_Limit:
		dir.y = -1
		
	if mouse_pos.y > viewport_rect.size.y - Edge_Limit:
		dir.y = 1
		
	dir = dir.normalized()
	
	if dir.length() == 0:
		dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	position += dir * SPEED * delta
	
	pass
