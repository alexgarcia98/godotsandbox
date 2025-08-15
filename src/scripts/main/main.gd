extends Node2D

@export var current_index = 0

@onready var timer: Timer = $Timer
@onready var ui: Control = $UI

var current = null
var max_levels
var red_opened = false
var green_opened = false

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
	
	max_levels = Messages.max_levels
	
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
	
	Messages.LevelStarted.emit(index)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_next_level() -> void:
	current_index = (current_index + 1) % (max_levels + 1)
	new_level = load("src/scenes/levels/level" + str(current_index) + ".tscn")
	load_level(current_index)

func on_restart() -> void:
	new_level = load("src/scenes/levels/level" + str(current_index) + ".tscn")
	reset_check = true
	load_level(current_index)
	
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
		timer.start()

func _on_timer_timeout():
	if not reset_check:
		print("current index: " + str(current_index))
		print("max levels: " + str(max_levels))
		current_index = (current_index + 1) % (max_levels + 1)
		new_level = load("src/scenes/levels/level" + str(current_index) + ".tscn")
		print("loading level "  + str(current_index))
		load_level(current_index)

func on_previous_level() -> void:
	current_index = (current_index - 1) % (max_levels + 1)
	if current_index < 0:
		current_index = max_levels
	new_level = load("src/scenes/levels/level" + str(current_index) + ".tscn")
	load_level(current_index)

func on_world_select():
	if current:
		current.queue_free()
	new_level = load("res://src/scenes/levelSelect/worldselect.tscn")
	ui.visible = false
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
	Messages.LevelStarted.emit(index)
	
func on_load_world(index):
	ui.visible = false
	if current:
		current.queue_free()
	new_level = load("src/scenes/levelSelect/levels" + str(index) + ".tscn")
	current = new_level.instantiate()
	add_child(current)
	
func on_unlock_levels():
	levels_unlocked = max_levels + 1
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
