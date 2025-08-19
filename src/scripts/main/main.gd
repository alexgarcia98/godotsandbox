extends Node2D

@export var current_index = 0

@onready var timer: Timer = $Timer
@onready var ui: Control = $UI
@onready var dimmer: ColorRect = $Dimmer
@onready var level_start: Control = $LevelStart
@onready var level_end: Control = $LevelEnd
@onready var level_name: Label = $LevelStart/MarginContainer/VBoxContainer/Panel/LevelName
@onready var start_level: Button = $LevelStart/MarginContainer/VBoxContainer/Panel3/MarginContainer/HBoxContainer/MarginContainer/StartLevel
@onready var level_select: Button = $LevelStart/MarginContainer/VBoxContainer/Panel3/MarginContainer/HBoxContainer/MarginContainer2/LevelSelect
@onready var best_time: Label = $LevelStart/MarginContainer/VBoxContainer/Panel2/HBoxContainer/Time
@onready var clear_time_end: Label = $LevelEnd/MarginContainer/VBoxContainer/Panel2/HBoxContainer/VBoxContainer2/ClearTime
@onready var best_time_end: Label = $LevelEnd/MarginContainer/VBoxContainer/Panel2/HBoxContainer/VBoxContainer2/BestTime
@onready var clear_rank: Label = $LevelEnd/MarginContainer/VBoxContainer/Panel2/HBoxContainer/VBoxContainer/ClearRank
@onready var best_rank: Label = $LevelEnd/MarginContainer/VBoxContainer/Panel2/HBoxContainer/VBoxContainer/BestRank
@onready var rank_start: Label = $LevelStart/MarginContainer/VBoxContainer/Panel2/HBoxContainer/Rank
@onready var sfx: AudioStreamPlayer2D = $sfx
@onready var sfx_ui: AudioStreamPlayer2D = $sfx_ui

var current = null
var red_opened = false
var green_opened = false
var old_clear
var old_rank

var levels_unlocked: int = 1
var filepath = "user://levels_unlocked.dat"

var new_level
var timer_running = false
var reset_check = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messages.connect("DoorToggled", on_door_toggled)
	Messages.connect("EndGame", on_end_game)
	Messages.connect("PreviousLevel", on_previous_level)
	Messages.connect("NextLevel", on_next_level)
	Messages.connect("Restart", on_restart)
	Messages.connect("MainMenu", on_main_menu)
	Messages.connect("WorldSelect", on_world_select)
	Messages.connect("LoadLevel", on_load_level)
	Messages.connect("LoadWorld", on_load_world)
	Messages.connect("UnlockLevels", on_unlock_levels)
	Messages.connect("LockLevels", on_lock_levels)
	Messages.connect("ResetLevelTime", on_reset_level_time)
	
	dimmer.visible = false
	dimmer.self_modulate.a = 0.5
	level_start.visible = false
	level_end.visible = false
	
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file == null:
		var err = FileAccess.get_open_error()
		if err == ERR_FILE_NOT_FOUND:
			# create new save data
			file = FileAccess.open(filepath, FileAccess.WRITE)
			var unlocked = 1
			file.store_var(unlocked)
			file.close()
			levels_unlocked = unlocked
	else:
		# load levels unlocked
		levels_unlocked = file.get_var()
		file.close()
	
	on_main_menu()
	
func on_main_menu():
	if current:
		current.queue_free()
	new_level = load("res://src/scenes/levels/mainmenu.tscn")
	ui.visible = false
	dimmer.visible = false
	level_start.visible = false
	level_end.visible = false
	current = new_level.instantiate()
	add_child(current)

func load_level(index):
	ui.visible = true
	if current:
		current.queue_free()
	current = new_level.instantiate()
	add_child(current)
	red_opened = false
	green_opened = false
	
	if (current_index + 1) > levels_unlocked:
		levels_unlocked = current_index + 1
		var write_file = FileAccess.open(filepath, FileAccess.WRITE)
		write_file.store_var(levels_unlocked)
		write_file.close()
	
	dimmer.visible = true
	var worldName = Messages.worldNames[current_index / 12]
	var levelName
	if current_index < Messages.levelNames.size():
		levelName = Messages.levelNames[current_index]
	else:
		levelName = str((current_index % 12) + 1)
	level_name.text = "%s: %s" % [worldName, levelName]
	var ms = Messages.saved_times[current_index]
	if ms == 5999999:
		best_time.text = "Best Time: No Time Set"
	else:
		var sec = floor(ms / 1000)
		var minute = floor(sec / 60)
		best_time.text = "Best Time: %02d:%02d.%03d" % [minute, (sec % 60), (ms % 1000)]
	level_start.visible = true
	old_clear = ms
	
	old_rank = "F"
	for i in range(Messages.rank_changes.size()):
		if ms < (Messages.ranks[current_index] * Messages.rank_changes[i] * 1000):
			old_rank = Messages.rank_assn[i]
			break
	if ms == 5999999:
		old_rank = "No Rank Achieved"
		rank_start.text = "No Rank Achieved"
	else:
		rank_start.text = "Best Rank: %s" % old_rank
	Messages.LevelStarted.emit(index)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_level_pressed() -> void:
	dimmer.visible = false
	level_start.visible = false
	level_end.visible = false
	Messages.audio.stream = Messages.progress_button_sound
	Messages.audio.play()
	Messages.BeginLevel.emit(current_index)

func on_next_level() -> void:
	current_index = (current_index + 1) % (Messages.max_levels + 1)
	new_level = load("src/scenes/levels/level" + str(current_index) + ".tscn")
	load_level(current_index)

func on_restart() -> void:
	new_level = load("src/scenes/levels/level" + str(current_index) + ".tscn")
	reset_check = true
	ui.visible = true
	if current:
		current.queue_free()
	current = new_level.instantiate()
	add_child(current)
	red_opened = false
	green_opened = false
	
	var ms = Messages.saved_times[current_index]
	if ms == 5999999:
		best_time.text = "Best Time: No Time Set"
	else:
		var sec = floor(ms / 1000)
		var minute = floor(sec / 60)
		best_time.text = "Best Time: %02d:%02d.%03d" % [minute, (sec % 60), (ms % 1000)]
	old_clear = ms
	old_rank = "F"
	for i in range(Messages.rank_changes.size()):
		if ms < (Messages.ranks[current_index] * Messages.rank_changes[i] * 1000):
			old_rank = Messages.rank_assn[i]
			break
	if ms == 5999999:
		rank_start.text = "No Rank Achieved"
		old_rank = "No Rank Achieved"
	else:
		rank_start.text = "Best Rank: %s" % old_rank
	
	Messages.BeginLevel.emit(current_index)
	
func on_door_toggled(player) -> void:
	# check sender
	if player == "red_player":
		red_opened = not red_opened
	elif player == "green_player":
		green_opened = not green_opened
	if red_opened and green_opened:
		Messages.LevelEnded.emit()
		timer_running = true
		reset_check = false
		sfx.stream = Messages.clear_sound
		sfx.play()
		timer.start()

func _on_timer_timeout():
	if not reset_check:
		dimmer.visible = true
		level_end.visible = true
		best_rank.visible = true
		best_time_end.visible = true
		if Messages.saved_times[current_index] < old_clear:
			# new record
			var new_ms = Messages.saved_times[current_index]
			var new_sec = floor(new_ms / 1000)
			var new_minute = floor(new_sec / 60)
			clear_time_end.text = "New Personal Best: %02d:%02d.%03d" % [new_minute, (new_sec % 60), (new_ms % 1000)]
			var old_ms = old_clear
			var old_sec = floor(old_ms / 1000)
			var old_minute = floor(old_sec / 60)
			best_time_end.text = "Previous Best: %02d:%02d.%03d" % [old_minute, (old_sec % 60), (old_ms % 1000)]
		else:
			var new_ms = ui.level_time_ms
			var new_sec = floor(new_ms / 1000)
			var new_minute = floor(new_sec / 60)
			clear_time_end.text = "Clear Time: %02d:%02d.%03d" % [new_minute, (new_sec % 60), (new_ms % 1000)]
			var old_ms = old_clear
			var old_sec = floor(old_ms / 1000)
			var old_minute = floor(old_sec / 60)
			best_time_end.text = "Best Time: %02d:%02d.%03d" % [old_minute, (old_sec % 60), (old_ms % 1000)]
		# find new rank
		var new_rank = "F"
		for i in range(Messages.rank_changes.size()):
			if ui.level_time_ms < (Messages.ranks[current_index] * Messages.rank_changes[i] * 1000):
				new_rank = Messages.rank_assn[i]
				break
		var old_rank_ind = Messages.rank_assn.find(old_rank)
		var new_rank_ind = Messages.rank_assn.find(new_rank)
		if new_rank_ind < old_rank_ind:
			clear_rank.text = "New Rank: %s" % new_rank
			best_rank.text = "Old Rank: %s" % old_rank
		else:
			clear_rank.text = "Clear Rank: %s" % new_rank
			best_rank.text = "Best Rank: %s" % old_rank
		if old_clear == 5999999:
			best_rank.visible = false
			best_time_end.visible = false
			
func on_previous_level() -> void:
	current_index = (current_index - 1) % (Messages.max_levels + 1)
	if current_index < 0:
		current_index = Messages.max_levels
	new_level = load("src/scenes/levels/level" + str(current_index) + ".tscn")
	load_level(current_index)

func on_world_select():
	if current:
		current.queue_free()
	new_level = load("res://src/scenes/levelSelect/worldselect.tscn")
	ui.visible = false
	dimmer.visible = false
	level_start.visible = false
	level_end.visible = false
	current = new_level.instantiate()
	add_child(current)
	
func on_load_level(index):
	ui.visible = true
	if current:
		current.queue_free()
	new_level = load("src/scenes/levels/level" + str(index) + ".tscn")
	current = new_level.instantiate()
	add_child(current)
	red_opened = false
	green_opened = false
	current_index = index
	dimmer.visible = true
	var worldName = Messages.worldNames[current_index / 12]
	var levelName
	if current_index < Messages.levelNames.size():
		levelName = Messages.levelNames[current_index]
	else:
		levelName = str((current_index % 12) + 1)
	level_name.text = "%s: %s" % [worldName, levelName]
	var ms = Messages.saved_times[current_index]
	if ms == 5999999:
		best_time.text = "Best Time: No Time Set"
	else:
		var sec = floor(ms / 1000)
		var minute = floor(sec / 60)
		best_time.text = "Best Time: %02d:%02d.%03d" % [minute, (sec % 60), (ms % 1000)]
	level_start.visible = true
	old_clear = ms
	old_rank = "F"
	for i in range(Messages.rank_changes.size()):
		if ms < (Messages.ranks[current_index] * Messages.rank_changes[i] * 1000):
			old_rank = Messages.rank_assn[i]
			break
	if ms == 5999999:
		old_rank = "No Rank Achieved"
		rank_start.text = "No Rank Achieved"
	else:
		rank_start.text = "Best Rank: %s" % old_rank
	Messages.LevelStarted.emit(index)
	
func on_reset_level_time(index):
	old_clear = 5999999
	old_rank = "No Rank Achieved"
	
func on_load_world(index):
	ui.visible = false
	dimmer.visible = false
	level_start.visible = false
	level_end.visible = false
	if current:
		current.queue_free()
	new_level = load("src/scenes/levelSelect/levels" + str(index) + ".tscn")
	current = new_level.instantiate()
	add_child(current)
	
func on_unlock_levels():
	levels_unlocked = Messages.max_levels + 1
	var write_file = FileAccess.open(filepath, FileAccess.WRITE)
	write_file.store_var(levels_unlocked)
	write_file.close()

func on_lock_levels():
	levels_unlocked = 1
	var write_file = FileAccess.open(filepath, FileAccess.WRITE)
	write_file.store_var(levels_unlocked)
	write_file.close()
	
func on_end_game():
	get_tree().quit()

func _on_level_select_pressed() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	on_world_select()

func _on_next_level_pressed() -> void:
	Messages.audio.stream = Messages.progress_button_sound
	Messages.audio.play()
	level_end.visible = false
	current_index = (current_index + 1) % (Messages.max_levels + 1)
	new_level = load("src/scenes/levels/level" + str(current_index) + ".tscn")
	load_level(current_index)

func _on_restart_level_pressed() -> void:
	Messages.audio.stream = Messages.progress_button_sound
	Messages.audio.play()
	dimmer.visible = false
	level_end.visible = false
	on_restart()
