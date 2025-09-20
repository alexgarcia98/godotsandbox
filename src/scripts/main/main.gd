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
@onready var red_death_animation: AnimationPlayer = $Node2D/RedDeath/RedDeathAnimation
@onready var green_death_animation: AnimationPlayer = $Node2D2/GreenDeath/GreenDeathAnimation
@onready var next_level: Button = $LevelEnd/MarginContainer/VBoxContainer/Panel3/MarginContainer/HBoxContainer/MarginContainer/NextLevel

var current = null
var red_opened = false
var green_opened = false
var settings_valid = false
var restart_valid = false
var old_clear
var old_rank
var settings_released = true

var timer_running = false
var reset_check = false
var world_clear_active = false

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
	Messages.connect("PlayerDied", on_player_died)
	Messages.connect("StopMovement", on_stop_movement)
	Messages.connect("ResumeMovement", on_resume_movement)
	Messages.connect("BeginLevel", on_begin_level)
	Messages.connect("LevelEnded", on_level_ended)
	Messages.connect("RemapActive", on_remap_active)
	Messages.connect("RemapInactive", on_remap_inactive)
	
	
	dimmer.visible = false
	dimmer.self_modulate.a = 0.5
	level_start.visible = false
	level_end.visible = false
	restart_valid = false
	settings_valid = false
	settings_released = true
	world_clear_active = false
	
	on_main_menu()
	
func load_level(index):
	if current:
		current.queue_free()
	current_index = index
	var level_index = Messages.get_save_index(index)
	var new_level = load("src/scenes/levels/level" + str(level_index) + ".tscn")
	current = new_level.instantiate()
	add_child(current)
	
	dimmer.visible = true
	level_start.visible = true
	restart_valid = false
	settings_valid = false
	start_level.grab_focus.call_deferred()
	init_level_data()
	Messages.LevelStarted.emit(index)

func init_level_data():
	ui.visible = true
	red_opened = false
	green_opened = false
	level_end.visible = false
	level_name.text = Messages.get_world_level_name(current_index)
	best_time.text = "Best Time: " + Messages.get_readable_stored_level_time(current_index)
	var ms = Messages.get_stored_level_time(current_index)
	old_clear = ms
	old_rank = Messages.get_stored_rank(current_index)
	if old_rank == "None":
		old_rank = "No Rank Achieved"
		rank_start.text = old_rank
	else:
		rank_start.text = "Best Rank: " + old_rank

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

func on_main_menu():
	if current:
		current.queue_free()
	var new_level = load("res://src/scenes/levels/mainmenu.tscn")
	ui.visible = false
	dimmer.visible = false
	level_start.visible = false
	level_end.visible = false
	restart_valid = false
	settings_valid = false
	current = new_level.instantiate()
	add_child(current)

func on_next_level() -> void:
	var index = (current_index + 1) % (Messages.max_levels + 1)
	if (current_index + 1) % 12 == 0:
		if world_clear_active:
			world_clear_active = false
			if current_index == Messages.max_levels:
				clear_screen()
			else:
				load_level(index)
		else:
			world_clear(current_index / 12)
	else:
		load_level(index)

func on_restart() -> void:
	var level_index = Messages.get_save_index(current_index)
	var new_level = load("src/scenes/levels/level" + str(level_index) + ".tscn")
	reset_check = true
	dimmer.visible = false
	level_end.visible = false
	level_start.visible = false
	if current:
		current.queue_free()
	current = new_level.instantiate()
	add_child(current)
	init_level_data()
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
		next_level.grab_focus.call_deferred()
		var new_clear = Messages.get_stored_level_time(current_index)
		if new_clear < old_clear:
			# new record
			clear_time_end.text = "New Personal Best: " + Messages.get_readable_stored_level_time(current_index)
			best_time_end.text = "Previous Best: " + Messages.get_readable_time(old_clear)
		else:
			clear_time_end.text = "Clear Time: " + Messages.get_readable_time(ui.level_time_ms)
			best_time_end.text = "Best Time: " + Messages.get_readable_time(old_clear)
			
		# find new rank
		var new_rank = Messages.get_rank_from_time(current_index, ui.level_time_ms)
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
	var index = (current_index - 1) % (Messages.max_levels + 1)
	if index < 0:
		index = Messages.max_levels
	load_level(index)

func on_world_select():
	if current:
		current.queue_free()
	var new_level = load("res://src/scenes/levelSelect/worldselect.tscn")
	ui.visible = false
	dimmer.visible = false
	level_start.visible = false
	level_end.visible = false
	restart_valid = false
	settings_valid = false
	current = new_level.instantiate()
	add_child(current)
	
func clear_screen():
	if current:
		current.queue_free()
	var new_level = load("res://src/scenes/levels/clearscreen.tscn")
	ui.visible = false
	dimmer.visible = false
	level_start.visible = false
	level_end.visible = false
	restart_valid = false
	settings_valid = false
	current = new_level.instantiate()
	add_child(current)
	
func world_clear(world_index):
	if current:
		current.queue_free()
	var new_level = load("res://src/scenes/levels/clearworld.tscn")
	ui.visible = false
	dimmer.visible = false
	level_start.visible = false
	level_end.visible = false
	restart_valid = false
	settings_valid = false
	current = new_level.instantiate()
	current.world_number = world_index
	add_child(current)
	world_clear_active = true
	
func on_load_level(index):
	load_level(index)
	
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
	var new_level = load("src/scenes/levelSelect/levelselect.tscn")
	current = new_level.instantiate()
	current.world_level = index
	add_child(current)
	
func on_unlock_levels():
	Messages.unlock_levels()

func on_lock_levels():
	Messages.lock_levels()
	
func on_end_game():
	get_tree().quit()
	
func on_player_died(player) -> void:
	if player.name == "red_player":
		red_death_animation.play("death")
	if player.name == "green_player":
		green_death_animation.play("death")

func _on_level_select_pressed() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	on_world_select()

func _on_next_level_pressed() -> void:
	Messages.audio.stream = Messages.progress_button_sound
	Messages.audio.play()
	on_next_level()

func _on_restart_level_pressed() -> void:
	Messages.audio.stream = Messages.progress_button_sound
	Messages.audio.play()
	on_restart()

func on_stop_movement():
	restart_valid = false

func on_resume_movement():
	restart_valid = true
	
func on_begin_level(_level):
	restart_valid = true
	settings_valid = true
	
func on_level_ended():
	restart_valid = true
	settings_valid = false

func on_remap_active():
	settings_valid = false

func on_remap_inactive():
	settings_valid = true

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('restart'):
		if restart_valid:
			Messages.Restart.emit()
	elif Input.is_action_just_pressed('settings'):
		if settings_valid and settings_released and remap:
			settings_released = false
			print("settings pressed")
			Messages.Settings.emit()
	elif Input.is_action_just_released("settings"):
		print("settings released")
		settings_released = true
	#elif Input.is_action_just_pressed('move_up'):
		#print("pressing ui up")
		#Input.action_press("ui_up")
	#elif Input.is_action_just_pressed('move_down'):
		#print("pressing ui down")
		#Input.action_press("ui_down")
	#elif Input.is_action_just_pressed('move_left'):
		#print("pressing ui left")
		#Input.action_press("ui_left")
	#elif Input.is_action_just_pressed('move_right'):
		#print("pressing ui right")
		#Input.action_press("ui_right")
	
