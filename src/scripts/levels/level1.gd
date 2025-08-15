extends TileMapLayer

@onready var label: Label = $Label
@onready var label_3: Label = $Label3

var actions = ["jump"]
var action_strings = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messages.connect("ButtonRemapped", on_button_remapped)
	on_button_remapped("", "")

func on_button_remapped(_action, _key):
	for a in actions:
		var event = InputEventKey.new()
		event.physical_keycode = Messages.rebinds[a]
		if event.as_text().ends_with(" (Physical)"):
			action_strings[a] = event.as_text().substr(0, (event.as_text().length() - 11))
		else:
			action_strings[a] = event.as_text()
	label.text = "Jump with %s" % [
		action_strings["jump"]
	]
