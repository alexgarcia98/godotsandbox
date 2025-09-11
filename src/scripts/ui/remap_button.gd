extends Button

class_name RemapButton
@export var action: String
@export var controller: bool = false
var key: Key
var button: JoyButton
var axis: JoyAxis
var value

var key_set = false
var button_set = false
var axis_set = false

func _init():
	toggle_mode = true
	#theme_type_variation = "RemapButton"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_unhandled_input(false)
	init_text()

func init_text():
	text = ""
	var events = InputMap.action_get_events(action)
	for event in events:
		if not controller:
			if event is InputEventKey:
				text = Messages.get_event_text(event)
				break
		else:
			if event is InputEventJoypadButton:
				text = Messages.get_event_text(event)
				break
			elif event is InputEventJoypadMotion:
				text = Messages.get_event_text(event)
				break
	print("init button %s to %s, controller %s" % [action, text, controller])

func update_key_text():
	text = ""
	var events = InputMap.action_get_events(action)
	for event in events:
		if not controller:
			if event is InputEventKey:
				text = Messages.get_event_text(event)
				break
		else:
			if event is InputEventJoypadButton:
				text = Messages.get_event_text(event)
				break
			elif event is InputEventJoypadMotion:
				text = Messages.get_event_text(event)
				break
	print("updating button %s to %s, controller %s" % [action, text, controller])
	
	
func _toggled(button_pressed):
	set_process_unhandled_input(button_pressed)
	if button_pressed:
		text = "..."
		release_focus()
	else:
		update_key_text()
		grab_focus()
		if key_set:
			Messages.KeyboardRemapped.emit(action, key)
			key_set = false
		elif button_set:
			Messages.JoypadButtonRemapped.emit(action, button)
			button_set = false
		elif axis_set:
			Messages.JoypadAxisRemapped.emit(action, axis, value)
			axis_set = false

func _unhandled_input(event) -> void:
	key_set = false
	button_set = false
	axis_set = false
	if event is InputEventKey and not controller:
		if event.pressed:
			Messages.erase_keyboard_events(action)
			InputMap.action_add_event(action, event)
			key = event.physical_keycode
			key_set = true
			button_pressed = false
	elif event is InputEventJoypadButton and controller:
		if event.pressed:
			Messages.erase_controller_events(action)
			InputMap.action_add_event(action, event)
			button = event.button_index
			button_set = true
			button_pressed = false
	elif event is InputEventJoypadMotion and controller:
		if event.axis_value < 0.2 and event.axis_value > -0.2:
			pass
		else:
			if event.axis_value < 0:
				event.axis_value = -1
			elif event.axis_value > 0:
				event.axis_value = 1
			Messages.erase_controller_events(action)
			InputMap.action_add_event(action, event)
			InputMap.action_set_deadzone(action, 0.2)
			axis = event.axis
			value = event.axis_value
			axis_set = true
			button_pressed = false
