extends CanvasLayer
class_name GUI

@onready var rtl_info := $RichTextLabelInfo

enum {
	ResourceButton
}

const scenes = {
	ResourceButton:preload("res://theLudovyc/GUI/ResourceButton.tscn")
}

func set_rtl_info_text(text:String):
	rtl_info.text = text
	
func set_rtl_info_text_money_cost(amount:int):
	rtl_info.clear()
	
	rtl_info.append_text("[center]" + str(amount) + " ")
	rtl_info.add_image(TheBank.money_icon, 20)

func set_rtl_visibility(b:bool):
	rtl_info.visible = b
