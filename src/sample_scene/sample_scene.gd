extends Node2D

@export var current_index = 1

@onready var timer: Timer = $Timer
@onready var ui: Control = $UI

var current = null
var max_levels = 12
var red_opened = false
var green_opened = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messages.connect("DoorOpened", on_door_opened)
	Messages.connect("EndGame", on_end_game)
	Messages.connect("StartGame", on_start_game)
	Messages.connect("PreviousLevel", on_previous_level)
	Messages.connect("NextLevel", on_next_level)
	Messages.connect("Restart", on_restart)
	Messages.connect("MainMenu", on_main_menu)
	on_main_menu()
	
func on_main_menu():
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
	var new_level = load("src/levels/level" + str(index) + ".tscn")
	current = new_level.instantiate()
	add_child(current)
	Messages.LevelStarted.emit(index)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_next_level() -> void:
	current_index = (current_index + 1) % (max_levels + 1)
	load_level(current_index)

func on_restart() -> void:
	load_level(current_index)
	
func on_door_opened(obj_name) -> void:
	# check sender
	if obj_name == "red_door":
		red_opened = true
	elif obj_name == "green_door":
		green_opened = true
	if red_opened and green_opened:
		Messages.LevelEnded.emit()
		timer.start()

func _on_timer_timeout():
	current_index = (current_index + 1) % (max_levels + 1)
	load_level(current_index)

func on_previous_level() -> void:
	current_index = (current_index - 1) % (max_levels + 1)
	if current_index < 0:
		current_index = max_levels
	load_level(current_index)

func on_start_game():
	load_level(current_index)
	
func on_end_game():
	get_tree().quit()
