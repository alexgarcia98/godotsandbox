extends TileMapLayer

@onready var label: Label = $Label
@onready var label_2: Label = $Label2

var actions = ["throw"]
var action_strings = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messages.connect("ButtonRemapped", on_button_remapped)
	on_button_remapped("", "")

func on_button_remapped(action, key):
	for a in actions:
		var event = InputEventKey.new()
		event.physical_keycode = Messages.rebinds[a]
		if event.as_text().ends_with(" (Physical)"):
			action_strings[a] = event.as_text().substr(0, (event.as_text().length() - 11))
		else:
			action_strings[a] = event.as_text()
	label_2.text = "Press %s to throw the secondary character\nChange the direction of the throw by holding\nleft, right, or up before pressing %s" % [
		action_strings["throw"],
		action_strings["throw"]
	]
