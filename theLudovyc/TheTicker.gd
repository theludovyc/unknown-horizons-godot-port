extends Timer

signal tick
signal cycle

var cycle_cooldown := 2
var current_ticks := 0

func _on_timeout():
	tick.emit()
	
	current_ticks += 1
	
	if current_ticks >= cycle_cooldown:
		current_ticks = 0
		
		cycle.emit()
