extends CanvasLayer

@onready var rtl_info := $RichTextLabelInfo

func set_rtl_info_text(text:String):
	rtl_info.text = text
	
func set_rtl_info_text_money_cost(amount:int):
	rtl_info.clear()
	
	rtl_info.append_text("[center]" + str(amount) + " ")
	rtl_info.add_image(Resources.Icons[Resources.Types.Money], 20)

func set_rtl_visibility(b:bool):
	rtl_info.visible = b
