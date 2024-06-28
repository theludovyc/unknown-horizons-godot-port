extends PanelContainer

@onready var rtl := $VBoxContainer/PanelContainer/RichTextLabel

func set_building_info(building_type:Buildings.Types):
	rtl.clear()
	
	if Buildings.Costs.has(building_type):
		rtl.add_text("Cost :\n")
		
		var building_costs = Buildings.Costs[building_type]
		
		for i in range(building_costs.size()):
			var cost = building_costs[i]
			
			if i > 0:
				rtl.add_text(" / ")
			
			rtl.add_text(str(cost[1]) + " ")
			rtl.add_image(Resources.Icons[cost[0]], 20)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
