extends Control

@onready var previous_level: Button = $FullUIContainer/UIMargins/Elements/Left/HBoxContainer/Levels/LevelNavigator/PreviousLevel
@onready var next_level: Button = $FullUIContainer/UIMargins/Elements/Left/HBoxContainer/Levels/LevelNavigator/NextLevel
@onready var restart: Button = $FullUIContainer/UIMargins/Elements/Left/HBoxContainer/Levels/Restart
@onready var deaths: Label = $"FullUIContainer/UIMargins/Elements/Left/HBoxContainer/Deaths+Reset/Deaths"
@onready var reset_times: Button = $"FullUIContainer/UIMargins/Elements/Left/HBoxContainer/Deaths+Reset/ResetTimes"
@onready var personal_best: Label = $FullUIContainer/UIMargins/Elements/Times/PersonalBest
@onready var level_time: Label = $FullUIContainer/UIMargins/Elements/Times/LevelTime
@onready var red_ammo: Label = $FullUIContainer/UIMargins/Elements/Right/HBoxContainer/Ammo/RedAmmo
@onready var green_ammo: Label = $FullUIContainer/UIMargins/Elements/Right/HBoxContainer/Ammo/GreenAmmo
@onready var main_menu: Button = $FullUIContainer/UIMargins/Elements/Right/HBoxContainer/Menu/MainMenu
@onready var controls: Button = $FullUIContainer/UIMargins/Elements/Right/HBoxContainer/Menu/Controls
@onready var help: Window = $Help

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


var main_scene: Node2D

var red_ammo_count = 10
var green_ammo_count = 10
var level_start_time = 0
var current_time = 0
var level_time_ms = 0
var level_deaths = 0
var level_ended: bool = false
var current_index = 0
var max_levels

var filepath = "user://save_data.dat"
var filepath2 = "user://controls.dat"
var saved_times = {}
var write_file

var action_items = [
	"move_left", 
	"move_right",
	"move_up",
	"move_down",
	"jump",
	"dash",
	"action",
	"freeze",
	"throw",
	"shoot",
	"switch",
	"pivot"
]

var button_dict = {
	"move_left": "Left", 
	"move_right": "Right",
	"move_up": "Up",
	"move_down": "Down",
	"jump": "Jump",
	"dash": "Dash/Airdash",
	"pivot": "Pivot",
	"action": "Interact",
	"throw": "Throw",
	"freeze": "Freeze",
	"switch": "Switch",
	"shoot": "Shoot"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messages.connect("PlayerDied", on_player_died)
	Messages.connect("ShotFired", on_shot_fired)
	Messages.connect("LevelStarted", on_level_started)
	Messages.connect("LevelEnded", on_level_ended)
	Messages.connect("ButtonRemapped", on_button_remapped)
	main_scene = get_parent()
	max_levels = main_scene.max_levels
	
	var action_dict = {
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
	
	# check if save data exists
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file == null:
		var err = FileAccess.get_open_error()
		if err == ERR_FILE_NOT_FOUND:
			# create new save data
			file = FileAccess.open(filepath, FileAccess.WRITE)
			var times = {}
			for i in range(max_levels + 1):
				var level_name = "level" + str(i)
				times[level_name] = 5999999
			file.store_var(times)
			file.close()
			saved_times = times
	else:
		# load saved times
		saved_times = file.get_var()
		file.close()
		
	# check if input remaps exist
	var file2 = FileAccess.open(filepath2, FileAccess.READ)
	if file2 == null:
		var err = FileAccess.get_open_error()
		if err == ERR_FILE_NOT_FOUND:
			file2 = FileAccess.open(filepath2, FileAccess.WRITE)
			var controls = {}
			for action in action_items:
				controls[action] = InputMap.action_get_events(action)[0].physical_keycode
			file2.store_var(controls)
			file2.close()
			Messages.rebinds = controls
	else:
		Messages.rebinds = file2.get_var()
		file2.close()
		for action in Messages.rebinds.keys():
			var event = InputEventKey.new()
			event.physical_keycode = Messages.rebinds[action]
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, event)
			print("initializing remap of " + action + " to " + str(Messages.rebinds[action]))
			var key_name = event.as_text()
			if key_name.ends_with(" (Physical)"):
				key_name = "%s" % key_name.substr(0, (key_name.length() - 11))
			action_dict[action].text = key_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not (level_ended):
		current_time = Time.get_ticks_msec()
		level_time_ms = current_time - level_start_time
		var sec = floor(level_time_ms / 1000)
		var minute = floor(sec / 60)
		level_time.text = "%02d:%02d:%03d" % [minute, (sec % 60), (level_time_ms % 1000)]

# button press handlers

func _on_previous_level_pressed() -> void:
	previous_level.release_focus()
	if not (level_ended):
		if current_index > 0:
			Messages.PreviousLevel.emit()


func _on_next_level_pressed() -> void:
	next_level.release_focus()
	if not (level_ended):
		if current_index < main_scene.levels_unlocked:
			Messages.NextLevel.emit()


func _on_restart_pressed() -> void:
	restart.release_focus()
	if not (level_ended):
		Messages.Restart.emit()


func _on_reset_times_pressed() -> void:
	reset_times.release_focus()
	if not (level_ended):
		# create new save data
		var file = FileAccess.open(filepath, FileAccess.WRITE)
		var times = {}
		for i in range(max_levels + 1):
			var level_name = "level" + str(i)
			times[level_name] = 5999999
		file.store_var(times)
		file.close()
		saved_times = times
		var ms = saved_times["level" + str(current_index)]
		var sec = floor(ms / 1000)
		var minute = floor(sec / 60)
		personal_best.text = "Best: %02d:%02d:%03d" % [minute, (sec % 60), (ms % 1000)]


func _on_main_menu_pressed() -> void:
	main_menu.release_focus()
	Messages.MainMenu.emit()


func _on_controls_pressed() -> void:
	help.show()

func _on_help_close_requested() -> void:
	help.hide()
	controls.release_focus()

# incoming signal handlers

func on_player_died(player_name) -> void:
	level_deaths += 1
	level_start_time -= 5000
	deaths.text = "Deaths: " + str(level_deaths)

func on_shot_fired(name):
	if name == "red_player":
		red_ammo_count -= 1
		red_ammo.text = "Red Ammo: %s" % red_ammo_count
	elif name == "green_player":
		green_ammo_count -= 1
		green_ammo.text = "Green Ammo: %s" % green_ammo_count

func on_level_started(index):
	current_time = 0
	level_time_ms = 0
	level_ended = false
	level_time.text = "00:00:000"
	
	current_index = index
	level_deaths = 0
	deaths.text = "Deaths: " + str(level_deaths)
	if not saved_times.has("level" + str(current_index)):
		saved_times["level" + str(current_index)] = 5999999
		var file = FileAccess.open(filepath, FileAccess.WRITE)
		file.store_var(saved_times)
		file.close()
	var ms = saved_times["level" + str(current_index)]
	var sec = floor(ms / 1000)
	var minute = floor(sec / 60)
	personal_best.text = "Best: %02d:%02d:%03d" % [minute, (sec % 60), (ms % 1000)]
	red_ammo_count = main_scene.current.get_node("red_player").ammo
	green_ammo_count = main_scene.current.get_node("green_player").ammo
	red_ammo.text = "Red Ammo: %s" % red_ammo_count
	green_ammo.text = "Green Ammo: %s" % green_ammo_count
	level_start_time = Time.get_ticks_msec()
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
	var sec = floor(level_time_ms / 1000)
	var minute = floor(sec / 60)
	level_time.text = "%02d:%02d:%03d" % [minute, (sec % 60), (level_time_ms % 1000)]
	if level_time_ms < saved_times["level" + str(current_index)]:
		saved_times["level" + str(current_index)] = level_time_ms
		write_file = FileAccess.open(filepath, FileAccess.WRITE)
		write_file.store_var(saved_times)
		write_file.close()
		var ms = saved_times["level" + str(current_index)]
		sec = floor(ms / 1000)
		minute = floor(sec / 60)
		personal_best.text = "Best: %02d:%02d:%03d" % [minute, (sec % 60), (ms % 1000)]

func on_button_remapped(action, key):
	Messages.rebinds[action] = key
	write_file = FileAccess.open(filepath2, FileAccess.WRITE)
	write_file.store_var(Messages.rebinds)
	write_file.close()
	print("storing remap of " + action + " to " + str(key))
