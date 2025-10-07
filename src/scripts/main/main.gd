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
@onready var view_replay: Button = $LevelEnd/MarginContainer/VBoxContainer/Panel3/MarginContainer/HBoxContainer/MarginContainer4/ViewReplay
@onready var view_best_replay: Button = $LevelStart/MarginContainer/VBoxContainer/Panel3/MarginContainer/HBoxContainer/MarginContainer3/ViewBestReplay

var current = null
var red_opened = false
var green_opened = false
var settings_valid = false
var restart_valid = false
var old_clear
var old_rank
var settings_released = true
var replay_released = true
var replay_valid = false
var replay_active = false

var timer_running = false
var reset_check = false
var world_clear_active = false
var start_time
var next_action_time
var action_count = 0
var position_count = 0
var redp
var greenp
var level_start_ms = 0
var recording_active
var red_player
var green_player
var replay_end_time
var send_end_replay
var red_end_pos
var green_end_pos

var replay_actions = []
var replay_positions = []
var axis_active = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messages.connect("DoorToggled", on_door_toggled)
	Messages.connect("EndGame", on_end_game)
	Messages.connect("PreviousLevel", on_previous_level)
	Messages.connect("NextLevel", on_next_level)
	Messages.connect("NextWorld", on_next_world)
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
	Messages.connect("StoreReplay", on_store_replay)
	Messages.connect("ViewBestReplay", _on_view_best_replay_pressed)
	
	dimmer.visible = false
	dimmer.self_modulate.a = 0.5
	level_start.visible = false
	level_end.visible = false
	restart_valid = false
	settings_valid = false
	settings_released = true
	world_clear_active = false
	replay_released = true
	replay_valid = false
	replay_active = false
	recording_active = false
	send_end_replay = false
	
	axis_active = [
		false, false, false, false, false,
		false, false, false, false, false,
		false, false, false, false, false,
		false, false, false, false, false
	]
	
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
	replay_valid = false
	replay_active = false
	recording_active = false
	send_end_replay = false
	replay_actions = []
	replay_positions = []
	if current_index in Messages.replays:
		view_best_replay.disabled = false
	else:
		view_best_replay.disabled = true
	start_level.grab_focus.call_deferred()
	init_level_data()
	Messages.LevelStarted.emit(index)
	Messages.world_loaded(index / 12)

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
	red_player = current.get_node("red_player")
	green_player = current.get_node("green_player")

func _on_start_level_pressed() -> void:
	dimmer.visible = false
	level_start.visible = false
	level_end.visible = false
	Messages.audio.stream = Messages.progress_button_sound
	Messages.audio.play()
	replay_actions = []
	replay_positions = []
	Messages.clear_emulated_inputs()
	Messages.BeginLevel.emit(current_index)
	level_start_ms = Time.get_ticks_msec()
	recording_active = true

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
	replay_valid = false
	replay_active = false
	recording_active = false
	world_clear_active = false
	current = new_level.instantiate()
	add_child(current)
	Messages.menu_music()

func on_next_level() -> void:
	var index = Messages.get_next_level(current_index)
	var world_index = current_index / 12
	if index % 6 == 0:
		if index % 12 == 0:
			if world_clear_active:
				world_clear_active = false
				if current_index == Messages.max_levels:
					clear_screen()
				else:
					load_level(index)
			else:
				world_clear(current_index / 12)
		else:
			if world_clear_active:
				world_clear_active = false
				load_level(index)
			else:
				if world_index == 0 or world_index == 3 or world_index == 7 or world_index == 11:
					load_level(index)
				else:
					easy_world_clear(current_index / 12)
	else:
		load_level(index)

func on_next_world() -> void:
	var index = Messages.get_next_world(current_index)
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
	replay_actions = []
	replay_positions = []
	Messages.clear_emulated_inputs()
	Messages.BeginLevel.emit(current_index)
	level_start_ms = Time.get_ticks_msec()
	recording_active = true
	replay_active = false
	send_end_replay = false
	
func on_door_toggled(player) -> void:
	# check sender
	if player == "red_player":
		red_opened = not red_opened
	elif player == "green_player":
		green_opened = not green_opened
	if red_opened and green_opened:
		red_end_pos = current.get_node("objects").get_node("red_door").global_position
		red_end_pos.y += 8
		green_end_pos = current.get_node("objects").get_node("green_door").global_position
		green_end_pos.y += 8
		if send_end_replay:
			send_end_replay = false
			Messages.EndReplay.emit(replay_end_time)
		elif replay_active:
			send_end_replay = false
			Messages.EndReplay.emit(replay_end_time)
		else:
			Messages.LevelEnded.emit()
		timer_running = true
		reset_check = false
		recording_active = false
		sfx.stream = Messages.clear_sound
		sfx.play()
		timer.start()

func _on_timer_timeout():
	if not reset_check:
		red_player.modulate = Color.WHITE
		green_player.modulate = Color.WHITE
		red_player.modulate.a = 1
		red_player.modulate.a = 1
		dimmer.visible = true
		level_end.visible = true
		best_rank.visible = true
		best_time_end.visible = true
		next_level.grab_focus.call_deferred()
		var new_clear = Messages.get_stored_level_time(current_index)
		replay_end_time = ui.level_time_ms
		if replay_end_time >= 60000:
			view_replay.disabled = true
		else:
			view_replay.disabled = false
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
	replay_valid = false
	world_clear_active = false
	replay_active = false
	recording_active = false
	current = new_level.instantiate()
	add_child(current)
	Messages.menu_music()
	
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
	replay_valid = false
	replay_active = false
	recording_active = false
	current = new_level.instantiate()
	add_child(current)
	
func world_clear(world_index):
	world_clear_active = true
	if current:
		current.queue_free()
	var new_level = load("res://src/scenes/levels/clearworld.tscn")
	ui.visible = false
	dimmer.visible = false
	level_start.visible = false
	level_end.visible = false
	restart_valid = false
	settings_valid = false
	replay_valid = false
	replay_active = false
	recording_active = false
	current = new_level.instantiate()
	current.world_number = world_index
	add_child(current)

func easy_world_clear(world_index):
	world_clear_active = true
	if current:
		current.queue_free()
	var new_level = load("res://src/scenes/levels/clearworldeasy.tscn")
	ui.visible = false
	dimmer.visible = false
	level_start.visible = false
	level_end.visible = false
	restart_valid = false
	settings_valid = false
	replay_valid = false
	replay_active = false
	recording_active = false
	current = new_level.instantiate()
	current.world_number = world_index
	add_child(current)

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

func _on_view_replay_pressed() -> void:
	on_replay()

func _on_view_best_replay_pressed() -> void:
	replay_actions = Messages.replays[current_index][0]
	replay_positions = Messages.replays[current_index][1]
	red_end_pos = current.get_node("objects").get_node("red_door").global_position
	red_end_pos.y += 8
	green_end_pos = current.get_node("objects").get_node("green_door").global_position
	green_end_pos.y += 8
	replay_end_time = Messages.replays[current_index][2]
	on_replay()

func on_stop_movement():
	restart_valid = false
	replay_valid = false

func on_resume_movement():
	restart_valid = true
	replay_valid = true
	
func on_begin_level(_level):
	restart_valid = true
	settings_valid = true
	replay_valid = true
	
func on_level_ended():
	restart_valid = true
	settings_valid = false
	replay_valid = false

func on_remap_active():
	settings_valid = false
	replay_valid = false

func on_remap_inactive():
	settings_valid = true
	replay_valid = false
	
#func on_replay():
	#var level_index = Messages.get_save_index(current_index)
	#var new_level = load("src/scenes/levels/level" + str(level_index) + ".tscn")
	#reset_check = true
	#dimmer.visible = false
	#level_end.visible = false
	#level_start.visible = false
	#if current:
		#current.queue_free()
	#current = new_level.instantiate()
	#add_child(current)
	#init_level_data()
	#replay_active = true
	#if replay_actions.size() > 0:
		#next_action_time = replay_actions[0][0]
	#var next_action_time
	#action_count = 0
	#Messages.BeginLevel.emit(current_index)
	#level_start_ms = Time.get_ticks_msec()

func on_store_replay():
	Messages.store_replay(replay_actions, replay_positions, ui.level_time_ms, current_index)

func on_replay():
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
	replay_active = true
	recording_active = false
	action_count = 0
	position_count = 0
	if replay_actions.size() > 0:
		next_action_time = replay_actions[0][0]
	Messages.clear_emulated_inputs()
	Messages.Replay.emit()
	Messages.BeginLevel.emit(current_index)
	red_player.modulate = Color.RED
	red_player.modulate.a = 0.5
	green_player.modulate = Color.DARK_GREEN
	green_player.modulate.a = 0.5
	red_player.can_move = true
	green_player.can_move = true
	level_start_ms = Time.get_ticks_msec()
	#red_player.can_move = false
	#green_player.can_move = false

#func _process(delta: float) -> void:
	#if not replay_active:
		#return
	#if action_count >= replay_actions.size():
		#replay_active = false
		#return
	#var current_time = Time.get_ticks_msec() - level_start_ms
	#if current_time > next_action_time:
		#Input.parse_input_event(replay_actions[action_count][1])
		#action_count += 1
		#if action_count < replay_actions.size():
			#next_action_time = replay_actions[action_count][0]
		#else:
			#replay_active = false
			

func _process(delta: float) -> void:
	if not replay_active:
		return
	if action_count >= replay_actions.size():
		replay_active = false
		send_end_replay = true
		recording_active = false
		red_player.global_position = red_end_pos
		green_player.global_position = green_end_pos
		red_player.key_obtained = true
		green_player.key_obtained = true
		var event = InputEventAction.new()
		event.pressed = true
		event.action = "move_up"
		event.device = -5
		Input.parse_input_event(event)
		var event2 = InputEventAction.new()
		event2.pressed = false
		event2.action = "move_up"
		event2.device = -5
		Input.parse_input_event(event2)
		Messages.clear_emulated_inputs()
		return
	while(true):
		var event = replay_actions[action_count][1]
		var current_time = Time.get_ticks_msec() - level_start_ms
		if current_time > next_action_time:
			var input_event = InputEventAction.new()
			var stored_event = replay_actions[action_count][1]
			input_event.action = stored_event[0]
			input_event.pressed = stored_event[1]
			input_event.strength = stored_event[2]
			input_event.device = -5
			print("event: %s" % input_event)
			Input.parse_input_event(input_event)
			#red_player.movement_state_machine.process_input(input_event)
			#green_player.movement_state_machine.process_input(input_event)
			#print(input_event)
			action_count += 1
			if action_count < replay_actions.size():
				next_action_time = replay_actions[action_count][0]
			else:
				break
		else:
			break

func _physics_process(delta: float) -> void:
	if replay_active:
		if position_count < replay_positions.size():
			var pos = replay_positions[position_count]
			red_player.global_position = pos[0]
			green_player.global_position = pos[1]
			position_count += 1
		else:
			replay_active = false
			send_end_replay = true
			recording_active = false
			red_player.global_position = red_end_pos
			green_player.global_position = green_end_pos
			red_player.key_obtained = true
			green_player.key_obtained = true
			var event = InputEventAction.new()
			event.pressed = true
			event.action = "move_up"
			event.device = -5
			Input.parse_input_event(event)
			var event2 = InputEventAction.new()
			event2.pressed = false
			event2.action = "move_up"
			event2.device = -5
			Input.parse_input_event(event2)
			Messages.clear_emulated_inputs()
	elif recording_active:
		var pos1 = red_player.global_position
		var pos2 = green_player.global_position
		replay_positions.append([pos1, pos2])

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('restart'):
		if restart_valid and replay_released:
			restart_valid = false
			replay_released = false
			Messages.Restart.emit()
			print("emitted restart")
	elif Input.is_action_just_released('restart'):
		print("restart released")
		replay_released = true
		return
	elif Input.is_action_just_pressed('settings'):
		if settings_valid and settings_released and remap:
			settings_released = false
			print("settings pressed")
			Messages.Settings.emit()
	elif Input.is_action_just_released("settings"): 
		print("settings released")
		settings_released = true
	else:
		if not replay_active:
			if event is InputEventJoypadMotion:
				if abs(event.axis_value) < 0.05:
					return
			var input_time = Time.get_ticks_msec() - level_start_ms
			if input_time >= 60000:
				return
			var input_event_storage
			var strength = 0
			var valid = true
			if event is InputEventKey:
				if event.pressed:
					strength = 1
				if event.physical_keycode in Messages.action_lookup["keyboard"]:
					input_event_storage = [Messages.action_lookup["keyboard"][event.physical_keycode], event.pressed, strength]
			elif event is InputEventJoypadButton:
				if event.pressed:
					strength = 1
				if event.button_index in Messages.action_lookup["joypad_button"]:
					input_event_storage = [Messages.action_lookup["joypad_button"][event.button_index], event.pressed, strength]
			elif event is InputEventJoypadMotion:
				input_event_storage = ["joypad_axis", event.axis, event.axis_value]
				var pressed = true
				if abs(event.axis_value) < 0.2:
					pressed = false
				var axis = event.axis
				if event.axis_value < 0:
					axis = event.axis + 10
				if axis_active[axis] == pressed:
					valid = false
				else:
					if axis in Messages.action_lookup["joypad_axis"]:
						input_event_storage = [Messages.action_lookup["joypad_axis"][axis], pressed, event.axis_value]
						axis_active[axis] = pressed
			else:
				return
			if valid:
				replay_actions.append([input_time, input_event_storage])
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
	
