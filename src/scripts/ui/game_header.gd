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

@onready var help: Window = $Help
@onready var settingsWindow: Window = $Settings

# settings menu
@onready var help_text: Label = $Settings/MarginContainer/VBoxContainer/MarginContainer/PanelContainer/HelpText
@onready var stage_select: Button = $Settings/MarginContainer/VBoxContainer/Navigation/StageSelect
@onready var title: Button = $Settings/MarginContainer/VBoxContainer/Navigation/Title
@onready var exit: Button = $Settings/MarginContainer/VBoxContainer/Navigation/Exit
@onready var reset_times: Button = $Settings/MarginContainer/VBoxContainer/HBoxContainer/ResetTimes
@onready var controls: Button = $Settings/MarginContainer/VBoxContainer/HBoxContainer/Controls

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
	"pivot": 79
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
	"shoot": "Shoot"
}

var action_dict = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messages.connect("PlayerDied", on_player_died)
	Messages.connect("ShotFired", on_shot_fired)
	Messages.connect("LevelStarted", on_level_started)
	Messages.connect("LevelEnded", on_level_ended)
	Messages.connect("ButtonRemapped", on_button_remapped)
	Messages.connect("ResetControls", on_reset_controls)
	Messages.connect("BeginLevel", on_begin_level)
	main_scene = get_parent()
	max_levels = Messages.max_levels
	
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
		"shoot": shoot
	}
	
	# check if input remaps exist
	var file2 = FileAccess.open(filepath2, FileAccess.READ)
	if file2 == null:
		var err = FileAccess.get_open_error()
		if err == ERR_FILE_NOT_FOUND:
			file2 = FileAccess.open(filepath2, FileAccess.WRITE)
			var control_scheme = {}
			for a in action_items_dict.keys():
				control_scheme[a] = InputMap.action_get_events(a)[0].physical_keycode
			file2.store_var(control_scheme)
			file2.close()
			Messages.rebinds = control_scheme
	else:
		Messages.rebinds = file2.get_var()
		file2.close()
		for a in Messages.rebinds.keys():
			var event = InputEventKey.new()
			event.physical_keycode = Messages.rebinds[a]
			InputMap.action_erase_events(a)
			InputMap.action_add_event(a, event)
			print("initializing remap of " + a + " to " + str(Messages.rebinds[a]))
			var key_name = event.as_text()
			if key_name.ends_with(" (Physical)"):
				key_name = "%s" % key_name.substr(0, (key_name.length() - 11))
			action_dict[a].text = key_name

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
			Messages.PreviousLevel.emit()

func _on_next_level_pressed() -> void:
	Messages.audio.stream = Messages.stage_select_pressed_sound
	Messages.audio.play()
	next_level.release_focus()
	if not (level_ended):
		if current_index < main_scene.levels_unlocked:
			Messages.NextLevel.emit()

func _on_restart_pressed() -> void:
	Messages.audio.stream = Messages.progress_button_sound
	Messages.audio.play()
	restart.release_focus()
	Messages.Restart.emit()

func _on_reset_times_pressed() -> void:
	reset_times.release_focus()
	if not (level_ended):
		Messages.reset_level_time(current_index)
		personal_best.text = "Best: " + Messages.get_readable_stored_level_time(current_index)
		Messages.ResetLevelTime.emit(current_index)

func _on_controls_pressed() -> void:
	Messages.audio.stream = Messages.stage_select_pressed_sound
	Messages.audio.play()
	help.show()
	settingsWindow.hide()

func _on_help_close_requested() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	help.hide()
	settingsWindow.show()
	controls.release_focus()

func _on_settings_pressed() -> void:
	Messages.audio.stream = Messages.stage_select_pressed_sound
	Messages.audio.play()
	settingsWindow.show()
	help_text.text = ""

func _on_settings_close_requested() -> void:
	volume_file = FileAccess.open(filepath3, FileAccess.WRITE)
	var volume = []
	volume.append(master_volume.value)
	volume.append(music_volume.value)
	volume.append(sfx_volume.value)
	volume_file.store_var(volume)
	volume_file.close()
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	settingsWindow.hide()
	settings.release_focus()

func _on_stage_select_pressed() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	help.hide()
	settingsWindow.hide()
	Messages.emit_signal("WorldSelect")

func _on_title_pressed() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	help.hide()
	settingsWindow.hide()
	Messages.emit_signal("MainMenu")

func _on_exit_pressed() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	help.hide()
	settingsWindow.hide()
	Messages.emit_signal("EndGame")

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
	personal_best.text = "Best: " + Messages.get_readable_stored_level_time(current_index)
	red_ammo_count = main_scene.current.get_node("red_player").ammo
	green_ammo_count = main_scene.current.get_node("green_player").ammo
	red_ammo.text = "Red Ammo: %s" % red_ammo_count
	green_ammo.text = "Green Ammo: %s" % green_ammo_count
	if current_index == 0:
		previous_level.disabled = true
	else:
		previous_level.disabled = false
	if (current_index + 1) < main_scene.levels_unlocked:
		next_level.disabled = false
	else:
		next_level.disabled = true
	
func on_level_ended():
	level_ended = true
	current_time = Time.get_ticks_msec()
	level_time_ms = current_time - level_start_time
	level_time.text = Messages.get_readable_time(level_time_ms)
	print("game_header: entering update level time")
	Messages.update_level_time(current_index, level_time_ms)
	var best_time = Messages.get_readable_stored_level_time(current_index)
	print("game_header: best time: %s" % best_time)
	personal_best.text = "Best: " + best_time

func on_button_remapped(a, key):
	Messages.rebinds[a] = key
	write_file = FileAccess.open(filepath2, FileAccess.WRITE)
	write_file.store_var(Messages.rebinds)
	write_file.close()
	print("storing remap of " + a + " to " + str(key))

func on_reset_controls():
	var file2 = FileAccess.open(filepath2, FileAccess.WRITE)
	var control_scheme = {}
	var event
	for a in action_items_dict.keys():
		control_scheme[a] = action_items_dict[a]
		event = InputEventKey.new()
		event.physical_keycode = action_items_dict[a]
		InputMap.action_erase_events(a)
		InputMap.action_add_event(a, event)
		print("initializing remap of " + a + " to " + str(Messages.rebinds[a]))
		var key_name = event.as_text()
		if key_name.ends_with(" (Physical)"):
			key_name = "%s" % key_name.substr(0, (key_name.length() - 11))
		action_dict[a].text = key_name
	
	file2.store_var(control_scheme)
	file2.close()
	Messages.rebinds = control_scheme

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
