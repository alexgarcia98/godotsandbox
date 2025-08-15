extends Button

class_name RemapButton
@export var action: String
var key: Key

func _init():
	toggle_mode = true
	#theme_type_variation = "RemapButton"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_unhandled_input(false)
	update_key_text()

func update_key_text():
	var key_text = InputMap.action_get_events(action)[0].as_text()
	if key_text.ends_with(" (Physical)"):
		text = "%s" % key_text.substr(0, (key_text.length() - 11))
	else:
		text = "%s" % InputMap.action_get_events(action)[0].as_text()
	
func _toggled(button_pressed):
	set_process_unhandled_input(button_pressed)
	if button_pressed:
		text = "..."
		release_focus()
	else:
		update_key_text()
		grab_focus()
		Messages.ButtonRemapped.emit(action, key)

func _unhandled_input(event) -> void:
	if event is InputEventKey:
		if event.pressed:
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, event)
			key = event.physical_keycode
			button_pressed = false
		
