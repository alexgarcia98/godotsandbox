extends Control

@onready var personal_best: Label = $FullUIContainer/UIMargins/Elements/Times/PersonalBest
@onready var level_time: Label = $FullUIContainer/UIMargins/Elements/Times/LevelTime
@onready var previous_level: Button = $FullUIContainer/UIMargins/Elements/Left/VBoxContainer/HBoxContainer/Levels/LevelNavigator/PreviousLevel
@onready var next_level: Button = $FullUIContainer/UIMargins/Elements/Left/VBoxContainer/HBoxContainer/Levels/LevelNavigator/NextLevel
@onready var deaths: Label = $FullUIContainer/UIMargins/Elements/Left/VBoxContainer/HBoxContainer/Deaths/Deaths
@onready var red_ammo: Label = $FullUIContainer/UIMargins/Elements/Right/HBoxContainer/Ammo/RedAmmo
@onready var green_ammo: Label = $FullUIContainer/UIMargins/Elements/Right/HBoxContainer/Ammo/GreenAmmo
@onready var settings: Button = $FullUIContainer/UIMargins/Elements/Right/HBoxContainer/Menu/Settings
@onready var restart: Button = $FullUIContainer/UIMargins/Elements/Right/HBoxContainer/Menu/Restart
@onready var level_name: Label = $FullUIContainer/UIMargins/Elements/Left/VBoxContainer/Panel/LevelName

@onready var help: Control = $Help
@onready var settingsWindow: Control = $Settings
@onready var dimmer: ColorRect = $Dimmer
@onready var exit_help: Button = $Help/MarginContainer2/MarginContainer/ExitHelp
@onready var exit_settings: Button = $Settings/MarginContainer2/MarginContainer/ExitSettings

# settings menu
@onready var help_text: Label = $Settings/MarginContainer/VBoxContainer/MarginContainer/PanelContainer/HelpText
@onready var stage_select: Button = $Settings/MarginContainer/VBoxContainer/Navigation/StageSelect
@onready var title: Button = $Settings/MarginContainer/VBoxContainer/Navigation/Title
@onready var exit: Button = $Settings/MarginContainer/VBoxContainer/Navigation/Exit
@onready var reset_times: Button = $Settings/MarginContainer/VBoxContainer/HBoxContainer/ResetTimes
@onready var controls: Button = $Settings/MarginContainer/VBoxContainer/HBoxContainer/Controls
@onready var keyboard_inputs: Button = $Help/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/KeyboardInputs
@onready var controller_inputs: Button = $Help/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/ControllerInputs
@onready var keyboard_remaps: HBoxContainer = $Help/MarginContainer/VBoxContainer/HBoxContainer
@onready var controller_remaps: HBoxContainer = $Help/MarginContainer/VBoxContainer/HBoxContainer2
@onready var previous_level_button: Button = $Settings/MarginContainer/VBoxContainer/Navigation2/PreviousLevelButton
@onready var restart_button: Button = $Settings/MarginContainer/VBoxContainer/Navigation2/RestartButton
@onready var next_level_button: Button = $Settings/MarginContainer/VBoxContainer/Navigation2/NextLevelButton



# button remaps
@onready var move_left: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/move_left
@onready var move_right: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/move_right
@onready var move_up: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer3/move_up
@onready var move_down: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer4/move_down
@onready var jump: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer5/jump
@onready var dash: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer6/dash
@onready var action: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer/action
@onready var freeze: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer2/freeze
@onready var throw: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer3/throw
@onready var shoot: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer4/shoot
@onready var switch: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer5/switch
@onready var pivot: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer6/pivot
@onready var settings_remap_1: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer8/settings
@onready var restart_remap_1: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer8/restart

@onready var move_left_2: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/move_left
@onready var move_right_2: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer2/move_right
@onready var move_up_2: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer3/move_up
@onready var move_down_2: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer4/move_down
@onready var jump_2: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer5/jump
@onready var dash_2: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer6/dash
@onready var action_2: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/HBoxContainer/action
@onready var freeze_2: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/HBoxContainer2/freeze
@onready var throw_2: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/HBoxContainer3/throw
@onready var shoot_2: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/HBoxContainer4/shoot
@onready var switch_2: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/HBoxContainer5/switch
@onready var pivot_2: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/HBoxContainer6/pivot
@onready var settings_remap_2: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer8/settings
@onready var restart_remap_2: RemapButton = $Help/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/HBoxContainer8/restart

# volume
@onready var master_volume: HScrollBar = $Settings/MarginContainer/VBoxContainer/Volume/VBoxContainer/MasterVolume/HBoxContainer3/MasterVolume
@onready var music_volume: HScrollBar = $Settings/MarginContainer/VBoxContainer/Volume/VBoxContainer/MusicVolume/HBoxContainer3/MusicVolume
@onready var sfx_volume: HScrollBar = $Settings/MarginContainer/VBoxContainer/Volume/VBoxContainer/SFXVolume/HBoxContainer3/SFXVolume

var main_scene: Node2D

var red_ammo_count = 10
var green_ammo_count = 10
var level_start_time = 0
var current_time = 0
var level_time_ms = 0
var level_deaths = 0
var level_ended: bool = true
var current_index = 0
var max_levels

var filepath2 = "user://controls.dat"
var filepath4 = "user://controller.dat"
var filepath3 = "user://volume.dat"
var write_file
var volume_file

var action_items_dict = {
	"move_left": 65, 
	"move_right": 68,
	"move_up": 87,
	"move_down": 83,
	"jump": 32,
	"dash": 4194325,
	"action": 74,
	"freeze": 75,
	"throw": 76,
	"shoot": 85,
	"switch": 73,
	"pivot": 79,
	"settings": 4194305,
	"restart": 66
}

var action_items_dict_controller = {
	"move_left": ["joypad_axis", 0, -1], 
	"move_right": ["joypad_axis", 0, 1],
	"move_up": ["joypad_axis", 1, -1],
	"move_down": ["joypad_axis", 1, 1],
	"jump": ["joypad_button", 0, 0],
	"dash": ["joypad_axis", 5, 1],
	"action": ["joypad_button", 3, 0],
	"freeze": ["joypad_button", 10, 0],
	"throw": ["joypad_button", 2, 0],
	"shoot": ["joypad_button", 1, 0],
	"switch": ["joypad_axis", 4, 1],
	"pivot": ["joypad_button", 9, 0],
	"settings": ["joypad_button", 6, 0],
	"restart": ["joypad_button", 4, 0]
}

var button_dict = {
	"move_left": "Left", 
	"move_right": "Right",
	"move_up": "Up",
	"move_down": "Down",
	"jump": "Jump",
	"dash": "Dash",
	"pivot": "Pivot",
	"action": "Interact",
	"throw": "Throw",
	"freeze": "Freeze",
	"switch": "Switch",
	"shoot": "Shoot",
	"settings": "Settings",
	"restart": "Restart"
}

var action_dict = {}

var controller_action_dict = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messages.connect("PlayerDied", on_player_died)
	Messages.connect("ShotFired", on_shot_fired)
	Messages.connect("LevelStarted", on_level_started)
	Messages.connect("LevelEnded", on_level_ended)
	Messages.connect("KeyboardRemapped", on_keyboard_remapped)
	Messages.connect("JoypadButtonRemapped", on_joypad_button_remapped)
	Messages.connect("JoypadAxisRemapped", on_joypad_axis_remapped)
	Messages.connect("ResetControls", on_reset_controls)
	Messages.connect("BeginLevel", on_begin_level)
	Messages.connect("Settings", on_settings)
	Messages.connect("EndReplay", on_replay_ended)
	main_scene = get_parent()
	max_levels = Messages.max_levels
	
	dimmer.visible = false
	help.visible = false
	settingsWindow.visible = false
	
	# check if volume settings exist
	volume_file = FileAccess.open(filepath3, FileAccess.READ)
	if volume_file == null:
		var err = FileAccess.get_open_error()
		if err == ERR_FILE_NOT_FOUND:
			volume_file = FileAccess.open(filepath3, FileAccess.WRITE)
			var volume = []
			volume.append(db_to_linear(0))
			volume.append(db_to_linear(0))
			volume.append(db_to_linear(-12))
			volume_file.store_var(volume)
			volume_file.close()
			master_volume.value = volume[0]
			music_volume.value = volume[1]
			sfx_volume.value = volume[2]
	else:
		var volume = volume_file.get_var()
		volume_file.close()
		master_volume.value = volume[0]
		music_volume.value = volume[1]
		sfx_volume.value = volume[2]
	
	help_text.text = ""
	
	action_dict = {
		"move_left": move_left, 
		"move_right": move_right,
		"move_up": move_up,
		"move_down": move_down,
		"jump": jump,
		"dash": dash,
		"pivot": pivot,
		"action": action,
		"throw": throw,
		"freeze": freeze,
		"switch": switch,
		"shoot": shoot,
		"settings": settings_remap_1,
		"restart": restart_remap_1
	}
	
	controller_action_dict = {
		"move_left": move_left_2, 
		"move_right": move_right_2,
		"move_up": move_up_2,
		"move_down": move_down_2,
		"jump": jump_2,
		"dash": dash_2,
		"pivot": pivot_2,
		"action": action_2,
		"throw": throw_2,
		"freeze": freeze_2,
		"switch": switch_2,
		"shoot": shoot_2,
		"settings": settings_remap_2,
		"restart": restart_remap_2
	}
	
	# check if input remaps exist
	var file2 = FileAccess.open(filepath2, FileAccess.READ)
	if file2 == null:
		var err = FileAccess.get_open_error()
		if err == ERR_FILE_NOT_FOUND:
			file2 = FileAccess.open(filepath2, FileAccess.WRITE)
			var control_scheme = {}
			for a in action_items_dict.keys():
				print("current action: %s" % a)
				var temp = InputMap.action_get_events(a)
				for e in temp:
					if e is InputEventKey:
						control_scheme[a] = ["keyboard", e.physical_keycode, 0]
			file2.store_var(control_scheme)
			file2.close()
			Messages.rebinds = control_scheme
	else:
		Messages.rebinds = file2.get_var()
		file2.close()
		print("saved keyboard rebinds: %s" % Messages.rebinds)
		
		var first = Messages.rebinds.keys()[0]
		if Messages.rebinds[first] is not Array:
			# need to reconfigure
			for a in Messages.rebinds.keys():
				Messages.rebinds[a] = ["keyboard", Messages.rebinds[a], 0]
			file2 = FileAccess.open(filepath2, FileAccess.WRITE)
			file2.store_var(Messages.rebinds)
			file2.close()
			
		for a in Messages.rebinds.keys():
			var event
			if Messages.rebinds[a][0] == "keyboard":
				event = InputEventKey.new()
				event.physical_keycode = Messages.rebinds[a][1]
			elif Messages.rebinds[a][0] == "joypad_button":
				event = InputEventJoypadButton.new()
				event.button_index = Messages.rebinds[a][1]
			elif Messages.rebinds[a][0] == "joypad_axis":
				event = InputEventJoypadMotion.new()
				event.axis = Messages.rebinds[a][1]
				event.axis_value = Messages.rebinds[a][2]
			print("old event:")
			for x in InputMap.action_get_events(a):
				print(x.as_text())
			Messages.erase_keyboard_events(a)
			InputMap.action_add_event(a, event)
			print("initializing remap of " + a + " to " + str(Messages.rebinds[a][1]))
			action_dict[a].text = Messages.get_event_text(event)

	# check if input remaps exist for contoller
	var file4 = FileAccess.open(filepath4, FileAccess.READ)
	if file4 == null:
		var err = FileAccess.get_open_error()
		if err == ERR_FILE_NOT_FOUND:
			file4 = FileAccess.open(filepath4, FileAccess.WRITE)
			var control_scheme = {}
			for a in action_items_dict.keys():
				print("current action: %s" % a)
				var temp = InputMap.action_get_events(a)
				for e in temp:
					if e is InputEventJoypadButton:
						control_scheme[a] = ["joypad_button", e.button_index, 0]
						break
					elif e is InputEventJoypadMotion:
						control_scheme[a] = ["joypad_axis", e.axis, e.axis_value]
						break
			file4.store_var(control_scheme)
			file4.close()
			print(control_scheme)
			Messages.controller_rebinds = control_scheme
	else:
		Messages.controller_rebinds = file4.get_var()
		file4.close()
		print("saved controller rebinds: %s" % Messages.controller_rebinds)
		
		var first = Messages.controller_rebinds.keys()[0]
		if Messages.controller_rebinds[first] is not Array:
			# need to reconfigure
			for a in Messages.controller_rebinds.keys():
				print("current action: %s" % a)
				var temp = InputMap.action_get_events(a)
				for e in temp:
					if e is InputEventJoypadButton:
						Messages.controller_rebinds[a] = ["joypad_button", e.button_index, 0]
						break
					elif e is InputEventJoypadMotion:
						Messages.controller_rebinds[a] = ["joypad_axis", e.axis, e.axis_value]
						break
			file4 = FileAccess.open(filepath4, FileAccess.WRITE)
			file4.store_var(Messages.controller_rebinds)
			file4.close()
			
		for a in Messages.controller_rebinds.keys():
			var event
			if Messages.controller_rebinds[a][0] == "keyboard":
				event = InputEventKey.new()
				event.physical_keycode = Messages.controller_rebinds[a][1]
			elif Messages.controller_rebinds[a][0] == "joypad_button":
				event = InputEventJoypadButton.new()
				event.button_index = Messages.controller_rebinds[a][1]
			elif Messages.controller_rebinds[a][0] == "joypad_axis":
				event = InputEventJoypadMotion.new()
				event.axis = Messages.controller_rebinds[a][1]
				event.axis_value = Messages.controller_rebinds[a][2]
			print("old event:")
			for x in InputMap.action_get_events(a):
				print(x.as_text())
			Messages.erase_controller_events(a)
			InputMap.action_add_event(a, event)
			print("initializing remap of " + a + " to " + str(Messages.controller_rebinds[a][1]))
			controller_action_dict[a].text = Messages.get_event_text(event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not (level_ended):
		current_time = Time.get_ticks_msec()
		level_time_ms = current_time - level_start_time
		level_time.text = Messages.get_readable_time(level_time_ms)

# button press handlers

func _on_previous_level_pressed() -> void:
	Messages.audio.stream = Messages.stage_select_pressed_sound
	Messages.audio.play()
	previous_level.release_focus()
	if not (level_ended):
		if current_index > 0:
			settingsWindow.visible = false
			dimmer.visible = false
			exit_settings.release_focus()
			Messages.PreviousLevel.emit()

func _on_next_level_pressed() -> void:
	Messages.audio.stream = Messages.stage_select_pressed_sound
	Messages.audio.play()
	next_level.release_focus()
	if not (level_ended):
		if current_index < Messages.levels_unlocked:
			settingsWindow.visible = false
			dimmer.visible = false
			exit_settings.release_focus()
			Messages.NextLevel.emit()

func _on_restart_pressed() -> void:
	Messages.audio.stream = Messages.progress_button_sound
	Messages.audio.play()
	restart.release_focus()
	settingsWindow.visible = false
	dimmer.visible = false
	exit_settings.release_focus()
	Messages.Restart.emit()

func _on_reset_times_pressed() -> void:
	if not (level_ended):
		Messages.reset_level_time(current_index)
		personal_best.text = "Best: " + Messages.get_readable_stored_level_time(current_index)
		Messages.ResetLevelTime.emit(current_index)

func _on_controls_pressed() -> void:
	Messages.audio.stream = Messages.stage_select_pressed_sound
	Messages.audio.play()
	help.visible = true
	keyboard_remaps.show()
	controller_remaps.hide()
	settingsWindow.visible = false
	keyboard_inputs.grab_focus.call_deferred()
	Messages.emit_signal("RemapActive")

func _on_exit_help_pressed() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	help.visible = false
	settingsWindow.visible = true
	exit_settings.grab_focus.call_deferred()
	Messages.emit_signal("RemapInactive")

func _on_settings_pressed() -> void:
	Messages.audio.stream = Messages.stage_select_pressed_sound
	Messages.audio.play()
	settingsWindow.visible = true
	dimmer.visible = true
	help_text.text = ""
	restart_button.grab_focus.call_deferred()
	Messages.emit_signal("StopMovement")
	exit_settings.grab_focus.call_deferred()

func _on_exit_settings_pressed() -> void:
	volume_file = FileAccess.open(filepath3, FileAccess.WRITE)
	var volume = []
	volume.append(master_volume.value)
	volume.append(music_volume.value)
	volume.append(sfx_volume.value)
	volume_file.store_var(volume)
	volume_file.close()
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	settingsWindow.visible = false
	dimmer.visible = false
	exit_settings.release_focus()
	Messages.emit_signal("ResumeMovement")

func _on_stage_select_pressed() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	help.visible = false
	settingsWindow.visible = false
	dimmer.visible = false
	Messages.emit_signal("WorldSelect")

func _on_title_pressed() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	help.visible = false
	settingsWindow.visible = false
	dimmer.visible = false
	Messages.emit_signal("MainMenu")

func _on_exit_pressed() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	help.visible = false
	settingsWindow.visible = false
	dimmer.visible = false
	Messages.emit_signal("EndGame")

func _on_previous_level_button_pressed() -> void:
	_on_previous_level_pressed()

func _on_restart_button_pressed() -> void:
	_on_restart_pressed()

func _on_next_level_button_pressed() -> void:
	_on_next_level_pressed()

# help text

func _on_exit_mouse_entered() -> void:
	help_text.text = "Exit the game"

func _on_exit_mouse_exited() -> void:
	help_text.text = ""

func _on_title_mouse_entered() -> void:
	help_text.text = "Return to the Title Screen"

func _on_title_mouse_exited() -> void:
	help_text.text = ""

func _on_stage_select_mouse_entered() -> void:
	help_text.text = "Return to the Stage Select screen"

func _on_stage_select_mouse_exited() -> void:
	help_text.text = ""
	
func _on_reset_times_mouse_entered() -> void:
	help_text.text = "Clear best time from the current level"

func _on_reset_times_mouse_exited() -> void:
	help_text.text = ""

func _on_controls_mouse_entered() -> void:
	help_text.text = "View and remap controls"

func _on_controls_mouse_exited() -> void:
	help_text.text = ""

func _on_previous_level_button_mouse_entered() -> void:
	help_text.text = "Play previous level"

func _on_previous_level_button_mouse_exited() -> void:
	help_text.text = ""

func _on_restart_button_mouse_entered() -> void:
	help_text.text = "Restart current level"

func _on_restart_button_mouse_exited() -> void:
	help_text.text = ""

func _on_next_level_button_mouse_entered() -> void:
	help_text.text = "Play next level"

func _on_next_level_button_mouse_exited() -> void:
	help_text.text = ""

func _on_exit_settings_focus_entered() -> void:
	help_text.text = "Exit settings menu"

func _on_exit_settings_focus_exited() -> void:
	help_text.text = ""

func _on_exit_settings_mouse_entered() -> void:
	help_text.text = "Exit settings menu"

func _on_exit_settings_mouse_exited() -> void:
	help_text.text = ""

func _on_reset_times_focus_entered() -> void:
	help_text.text = "Clear best time from the current level"

func _on_reset_times_focus_exited() -> void:
	help_text.text = ""

func _on_controls_focus_entered() -> void:
	help_text.text = "View and remap controls"

func _on_controls_focus_exited() -> void:
	help_text.text = ""

func _on_previous_level_button_focus_entered() -> void:
	help_text.text = "Play previous level"

func _on_previous_level_button_focus_exited() -> void:
	help_text.text = ""

func _on_restart_button_focus_entered() -> void:
	help_text.text = "Restart current level"

func _on_restart_button_focus_exited() -> void:
	help_text.text = ""

func _on_next_level_button_focus_entered() -> void:
	help_text.text = "Play next level"

func _on_next_level_button_focus_exited() -> void:
	help_text.text = ""

func _on_stage_select_focus_entered() -> void:
	help_text.text = "Return to the Stage Select screen"

func _on_stage_select_focus_exited() -> void:
	help_text.text = ""

func _on_title_focus_entered() -> void:
	help_text.text = "Return to the Title Screen"

func _on_title_focus_exited() -> void:
	help_text.text = ""
	
func _on_exit_focus_entered() -> void:
	help_text.text = "Exit the game"

func _on_exit_focus_exited() -> void:
	help_text.text = ""

# incoming signal handlers

func on_player_died(player_name) -> void:
	level_deaths += 1
	level_start_time -= 5000
	deaths.text = "Deaths: " + str(level_deaths)

func on_shot_fired(player_name):
	if player_name == "red_player":
		red_ammo_count -= 1
		red_ammo.text = "Red Ammo: %s" % red_ammo_count
	elif player_name == "green_player":
		green_ammo_count -= 1
		green_ammo.text = "Green Ammo: %s" % green_ammo_count

func on_begin_level(index):
	current_time = 0
	level_time_ms = 0
	level_time.text = "00:00.000"
	current_index = index
	level_deaths = 0
	deaths.text = "Deaths: " + str(level_deaths)
	red_ammo_count = main_scene.current.get_node("red_player").ammo
	green_ammo_count = main_scene.current.get_node("green_player").ammo
	red_ammo.text = "Red Ammo: %s" % red_ammo_count
	green_ammo.text = "Green Ammo: %s" % green_ammo_count
	level_ended = false
	level_start_time = Time.get_ticks_msec()

func on_level_started(index):
	level_ended = true
	current_time = 0
	level_time_ms = 0
	level_time.text = "00:00.000"
	current_index = index
	level_deaths = 0
	deaths.text = "Deaths: " + str(level_deaths)
	level_name.text = Messages.get_world_level_name(current_index)
	if level_name.text.length() > 25:
		level_name.add_theme_font_size_override("font_size", 8)
	else:
		level_name.add_theme_font_size_override("font_size", 16)
	personal_best.text = "Best: " + Messages.get_readable_stored_level_time(current_index)
	red_ammo_count = main_scene.current.get_node("red_player").ammo
	green_ammo_count = main_scene.current.get_node("green_player").ammo
	red_ammo.text = "Red Ammo: %s" % red_ammo_count
	green_ammo.text = "Green Ammo: %s" % green_ammo_count
	if current_index == 0:
		previous_level.disabled = true
		previous_level_button.disabled = true
	else:
		previous_level.disabled = false
		previous_level_button.disabled = false
	if (current_index + 1) < Messages.levels_unlocked:
		next_level.disabled = false
		next_level_button.disabled = false
	else:
		next_level.disabled = true
		next_level_button.disabled = true
	
func on_level_ended():
	level_ended = true
	current_time = Time.get_ticks_msec()
	level_time_ms = current_time - level_start_time
	level_time.text = Messages.get_readable_time(level_time_ms)
	Messages.update_level_time(current_index, level_time_ms)
	var best_time = Messages.get_readable_stored_level_time(current_index)
	personal_best.text = "Best: " + best_time
	Messages.unlock_next_level(current_index)
	if current_index not in Messages.replays:
		Messages.StoreReplay.emit()
	elif level_time_ms < Messages.replays[current_index][2]:
		Messages.StoreReplay.emit()

func on_replay_ended(end_time):
	level_ended = true
	level_time_ms = end_time
	level_time.text = Messages.get_readable_time(level_time_ms)
	var best_time = Messages.get_readable_stored_level_time(current_index)
	personal_best.text = "Best: " + best_time

func on_keyboard_remapped(a, key):
	Messages.rebinds[a] = ["keyboard", key, 0]
	write_file = FileAccess.open(filepath2, FileAccess.WRITE)
	write_file.store_var(Messages.rebinds)
	write_file.close()
	print("storing remap of " + a + " to " + str(key))

func on_joypad_button_remapped(a, button):
	Messages.controller_rebinds[a] = ["joypad_button", button, 0]
	write_file = FileAccess.open(filepath4, FileAccess.WRITE)
	write_file.store_var(Messages.controller_rebinds)
	write_file.close()
	print("storing remap of " + a + " to " + str(button))

func on_joypad_axis_remapped(a, axis, value):
	var axis_value
	if value < 0:
		axis_value = -1
	else:
		axis_value = 1
	Messages.controller_rebinds[a] = ["joypad_axis", axis, axis_value]
	write_file = FileAccess.open(filepath4, FileAccess.WRITE)
	write_file.store_var(Messages.controller_rebinds)
	write_file.close()
	print("storing remap of " + a + " to " + str(axis))

func on_reset_controls():
	var file2 = FileAccess.open(filepath2, FileAccess.WRITE)
	var control_scheme = {}
	var file4 = FileAccess.open(filepath4, FileAccess.WRITE)
	var control_scheme_2 = {}
	var event
	var event_2
	control_scheme_2 = action_items_dict_controller
	for a in action_items_dict.keys():
		control_scheme[a] = ["keyboard", action_items_dict[a], 0]
		event = InputEventKey.new()
		event.physical_keycode = action_items_dict[a]
		if action_items_dict_controller[a][0] == "joypad_axis":
			event_2 = InputEventJoypadMotion.new()
			event_2.axis = action_items_dict_controller[a][1]
			event_2.axis_value = action_items_dict_controller[a][2]
		elif action_items_dict_controller[a][0] == "joypad_button":
			event_2 = InputEventJoypadButton.new()
			event_2.button_index = action_items_dict_controller[a][1]
		InputMap.action_erase_events(a)
		InputMap.action_add_event(a, event)
		InputMap.action_add_event(a, event_2)
		print("initializing remap of " + a + " to " + str(control_scheme[a][1]))
		action_dict[a].text = Messages.get_event_text(event)
		controller_action_dict[a].text = Messages.get_event_text(event_2)
	
	file2.store_var(control_scheme)
	file2.close()
	file4.store_var(control_scheme_2)
	file4.close()
	
	Messages.controller_rebinds = control_scheme_2
	Messages.rebinds = control_scheme

func on_settings():
	if settingsWindow.visible:
		_on_exit_settings_pressed()
	else:
		_on_settings_pressed()

func _on_master_volume_value_changed(value: float) -> void:
	var master_bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_linear(master_bus_index, value)
	var file3 = FileAccess.open(filepath3, FileAccess.READ)

func _on_music_volume_value_changed(value: float) -> void:
	var music_bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_linear(music_bus_index, value)

func _on_sfx_volume_value_changed(value: float) -> void:
	var sfx_bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_linear(sfx_bus_index, value)
	var movement_bus_index = AudioServer.get_bus_index("Movement")
	AudioServer.set_bus_volume_linear(movement_bus_index, value)
	var ui_bus_index = AudioServer.get_bus_index("UI")
	AudioServer.set_bus_volume_linear(ui_bus_index, value)

func _on_keyboard_inputs_pressed() -> void:
	keyboard_remaps.show()
	controller_remaps.hide()

func _on_controller_inputs_pressed() -> void:
	keyboard_remaps.hide()
	controller_remaps.show()
