extends Object
class_name Helper

static func get_string_from_signed_int(i:int):
	return ("+" if i >= 0 else "") + str(i)
