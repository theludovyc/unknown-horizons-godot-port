extends AudioStreamPlayer

const SOUNDS = {
	# Events/Scenario
	"lose": preload("res://Art/Sound/Events/Scenario/lose.ogg"),
	"win": preload("res://Art/Sound/Events/Scenario/win.ogg"),

	# Events
	"new_era": preload("res://Art/Sound/Events/new_era.ogg"),
	"new_settlement": preload("res://Art/Sound/Events/new_settlement.ogg"),

	# .
	"build": preload("res://Art/Sound/build.ogg"),
	"chapel": preload("res://Art/Sound/chapel.ogg"),
	"click": preload("res://Art/Sound/click.ogg"),
	"flippage": preload("res://Art/Sound/flippage.ogg"),
	"invalid": preload("res://Art/Sound/invalid.ogg"),
	"lumberjack": preload("res://Art/Sound/lumberjack.ogg"),
	"lumberjack_long": preload("res://Art/Sound/lumberjack_long.ogg"),
	"main_square": preload("res://Art/Sound/main_square.ogg"),
	"refresh": preload("res://Art/Sound/refresh.ogg"),
	"sheepfield": preload("res://Art/Sound/sheepfield.ogg"),
	"ships_bell": preload("res://Art/Sound/ships_bell.ogg"),
	"smith": preload("res://Art/Sound/smith.ogg"),
	"stonemason": preload("res://Art/Sound/stonemason.ogg"),
	"success": preload("res://Art/Sound/success.ogg"),
	"tavern": preload("res://Art/Sound/tavern.ogg"),
	"warehouse": preload("res://Art/Sound/warehouse.ogg"),
	"windmill": preload("res://Art/Sound/windmill.ogg"),

	# TODO: Possibly into distinct const?
	"de_0": preload("res://Art/Sound/Voice/De/0/NewWorld/0.ogg"),
	"de_1": preload("res://Art/Sound/Voice/De/0/NewWorld/1.ogg"),
	"de_2": preload("res://Art/Sound/Voice/De/0/NewWorld/2.ogg"),
	"de_3": preload("res://Art/Sound/Voice/De/0/NewWorld/3.ogg"),

	"en_0": preload("res://Art/Sound/Voice/En/0/NewWorld/0.ogg"),
	"en_1": preload("res://Art/Sound/Voice/En/0/NewWorld/1.ogg"),
	"en_2": preload("res://Art/Sound/Voice/En/0/NewWorld/2.ogg"),
	"en_3": preload("res://Art/Sound/Voice/En/0/NewWorld/3.ogg"),

	"fr_0": preload("res://Art/Sound/Voice/Fr/0/NewWorld/0.ogg"),
	"fr_1": preload("res://Art/Sound/Voice/Fr/0/NewWorld/1.ogg"),
	"fr_2": preload("res://Art/Sound/Voice/Fr/0/NewWorld/2.ogg"),
	"fr_3": preload("res://Art/Sound/Voice/Fr/0/NewWorld/3.ogg"),
}

var asp_click = AudioStreamPlayer.new()
var asp_build = AudioStreamPlayer.new()
var asp_voice = AudioStreamPlayer.new()

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	asp_click.bus = "Effects"
	asp_build.bus = "Effects"
	asp_voice.bus = "Voice"

	asp_click.stream = SOUNDS["click"]
	asp_build.stream = SOUNDS["build"]

func play_snd(snd_name: String, stream: AudioStream = null) -> void:
	var asp: AudioStreamPlayer = {
		"click": asp_click,
		"build": asp_build,
		"voice": asp_voice
	}.get(snd_name)

	# If a distinct AudioStreamPlayer exists for the requested sound,
	# use that one
	if asp != null:
		if stream: # Currently only used to pass different voice messages
			asp.stream = stream
		if asp.name.is_empty():
			add_child(asp)
		asp.play()
		#print_debug("Playing {0}".format([snd_name]))

	# Otherwise play it through the generic AudioStreamPlayer
	elif SOUNDS[snd_name]:
		self.stream = SOUNDS[snd_name]
		#if not name: # "@@2"
		#	add_child(self)
		play()
		#print_debug("Playing {0}".format([snd_name]))
	else:
		printerr("Sound {0} not found.".format([snd_name]))

func play_snd_click() -> void:
	play_snd("click")

func play_snd_fail() -> void:
	play_snd("build")

func play_snd_voice(voice_code: String) -> void:
	play_snd("voice", SOUNDS[voice_code])

func play_entry_snd() -> void:
	asp_voice.stream = SOUNDS["{0}_{1}".format([Config.language, randi() % 4])]
	if asp_voice.name.is_empty():
		add_child(asp_voice)
	asp_voice.play()

func set_volume(volume: float, bus_name: String) -> void:
	var index = AudioServer.get_bus_index(bus_name)
	print("Set volume for bus {0}({1}): {2}".format([bus_name, index, volume]))
	AudioServer.set_bus_volume_db(index, linear_to_db(volume / 100.0))

func set_master_volume(volume: float) -> void:
	set_volume(volume, "Master")

func set_voice_volume(volume: float) -> void:
	set_volume(volume, "Voice")

func set_effects_volume(volume: float) -> void:
	set_volume(volume, "Effects")

func set_music_volume(volume: float) -> void:
	set_volume(volume, "Music")
