extends Node2D

var current = null
var max_levels = 11
@export
var current_index = 1
var red_opened = false
var green_opened = false
var level_deaths = 0
var buttons_valid = true
@export var action_items: Array[String]

@onready var timer: Timer = $Timer
@onready var green_key: RichTextLabel = $UI/green_key
@onready var red_key: RichTextLabel = $UI/red_key
@onready var speedrun_timer: Label = $UI/speedrun_timer
@onready var deaths: Label = $UI/deaths
@onready var personal_best: Label = $UI/personal_best
@onready var reset_scores: Button = $UI/reset_scores
@onready var help: Window = $Help
@onready var settings_grid_container: GridContainer = $Help/MarginContainer/SettingsGridContainer
@onready var help_button: Button = $UI/help
@onready var ui: Control = $UI

var level_start_time = 0
var current_time = 0

var filepath = "user://save_data.dat"
var filepath2 = "user://controls.dat"

var saved_times = {}
var level_time_ms
var write_file

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
	Messages.connect("DoorOpened", on_door_opened)
	Messages.connect("PlayerDied", on_player_died)
	Messages.connect("ButtonRemapped", on_button_remapped)
	Messages.connect("EndGame", on_end_game)
	Messages.connect("StartGame", on_start_game)
	
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
	create_action_remap_items()
	load_menu()
	
func load_menu():
	if current:
		current.queue_free()
	var new_level = load("res://src/levels/mainmenu.tscn")
	ui.visible = false
	current = new_level.instantiate()
	add_child(current)

func load_level(index):
	ui.visible = true
	if current:
		current.queue_free()
	var new_level = load("src/levels/level" + str(current_index) + ".tscn")
	current = new_level.instantiate()
	add_child(current)
	current_index = index
	level_deaths = 0
	deaths.text = "Deaths: " + str(level_deaths)
	red_opened = false
	green_opened = false
	green_key.text = "No Green Key"
	red_key.text = "No Red Key"
	buttons_valid = true
	var ms = saved_times["level" + str(current_index)]
	var sec = floor(ms / 1000)
	var minute = floor(sec / 60)
	personal_best.text = "PB: %02d:%02d:%03d" % [minute, (sec % 60), (ms % 1000)]
	level_start_time = Time.get_ticks_msec()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not (red_opened and green_opened):
		current_time = Time.get_ticks_msec()
		level_time_ms = current_time - level_start_time
		var sec = floor(level_time_ms / 1000)
		var minute = floor(sec / 60)
		speedrun_timer.text = "%02d:%02d:%03d" % [minute, (sec % 60), (level_time_ms % 1000)]
	else:
		# check if better time
		if level_time_ms < saved_times["level" + str(current_index)]:
			saved_times["level" + str(current_index)] = level_time_ms
			write_file = FileAccess.open(filepath, FileAccess.WRITE)
			write_file.store_var(saved_times)
			write_file.close()
			var ms = saved_times["level" + str(current_index)]
			var sec = floor(ms / 1000)
			var minute = floor(sec / 60)
			personal_best.text = "PB: %02d:%02d:%03d" % [minute, (sec % 60), (ms % 1000)]

func _on_level_switch_pressed() -> void:
	if buttons_valid:
		current_index = (current_index + 1) % (max_levels + 1)
		load_level(current_index)

func _on_reset_level_pressed() -> void:
	if buttons_valid:
		load_level(current_index)
	
func on_door_opened(obj_name) -> void:
	# check sender
	if obj_name == "red_door":
		red_opened = true
	elif obj_name == "green_door":
		green_opened = true
	if red_opened and green_opened:
		buttons_valid = false
		timer.start()

func on_player_died(player_name) -> void:
	level_deaths += 1
	level_start_time -= 5000
	deaths.text = "Deaths: " + str(level_deaths)

func _on_timer_timeout():
	current_index = (current_index + 1) % (max_levels + 1)
	load_level(current_index)

func _on_exit_pressed() -> void:
	load_menu()

func _on_reset_scores_pressed() -> void:
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
	personal_best.text = "PB: %02d:%02d:%03d" % [minute, (sec % 60), (ms % 1000)]


func _on_level_switch_2_pressed() -> void:
	if buttons_valid:
		current_index = (current_index - 1) % (max_levels + 1)
		if current_index < 0:
			current_index = max_levels
		load_level(current_index)


func _on_help_pressed() -> void:
	help.show()

func _on_help_close_requested() -> void:
	help.hide()
	help_button.release_focus()

func create_action_remap_items() -> void:
	var previous_item = settings_grid_container.get_child(settings_grid_container.get_child_count() - 1)
	for index in range(action_items.size()):
		var action = action_items[index]
		var label = Label.new()
		label.text = action
		if button_dict.has(action):
			label.text = button_dict[action]
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		settings_grid_container.add_child(label)
		
		var button = RemapButton.new()
		button.action = action
		button.focus_neighbor_top = previous_item.get_path()
		previous_item.focus_neighbor_bottom = button.get_path()
		previous_item = button
		settings_grid_container.add_child(button)
		
func on_button_remapped(action, key):
	Messages.rebinds[action] = key
	write_file = FileAccess.open(filepath2, FileAccess.WRITE)
	write_file.store_var(Messages.rebinds)
	write_file.close()
	print("storing remap of " + action + " to " + str(key))

func on_start_game():
	load_level(current_index)
	
func on_end_game():
	get_tree().quit()
