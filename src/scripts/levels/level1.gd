extends TileMapLayer

@onready var label: Label = $Label
@onready var label_3: Label = $Label3

var actions = ["jump"]
var action_strings = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messages.connect("KeyboardRemapped", on_keyboard_remapped)
	Messages.connect("JoypadButtonRemapped", on_keyboard_remapped)
	Messages.connect("JoypadAxisRemapped", on_keyboard_remapped)
	on_keyboard_remapped("", "")

func on_keyboard_remapped(_action, _key):
	for a in actions:
		var event
		var event_type = Messages.rebinds[a][0]
		if event_type == "keyboard":
			event = InputEventKey.new()
			event.physical_keycode = Messages.rebinds[a][1]
		elif event_type == "joypad_button":
			event = InputEventJoypadButton.new()
			event.button_index = Messages.rebinds[a][1]
		elif event_type == "joypad_axis":
			event = InputEventJoypadMotion.new()
			event.axis = Messages.rebinds[a][1]
			event.axis_value = Messages.rebinds[a][2]
		action_strings[a] = Messages.get_event_text(event)
	print(action_strings)
	label.text = "Jump with %s" % [
		action_strings["jump"]
	]
