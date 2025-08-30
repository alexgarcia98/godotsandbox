extends TileMapLayer

@onready var label: Label = $Label
@onready var label_2: Label = $Label2
@onready var label_3: Label = $Label3

var actions = ["move_up", "move_down", "pivot"]
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
	label_2.text = "Press %s\nto move forwards\nand %s\nto move backwards" % [
		action_strings["move_up"],
		action_strings["move_down"]
	]
	
	label_3.text = "Press %s to turn\naround. You can do this\nin the air once per jump." % [
		action_strings["pivot"]
	]
