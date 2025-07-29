extends Node2D

var current = null
var max_levels = 2
var current_index = 0
var red_opened = false
var green_opened = false

@onready var timer: Timer = $Timer
@onready var label: Label = $UI/Label
@onready var green_key: RichTextLabel = $UI/green_key
@onready var red_key: RichTextLabel = $UI/red_key

var level_start_time = 0
var current_time = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messages.connect("DoorOpened", on_door_opened)
	load_level(current_index)

func load_level(index):
	if current:
		current.queue_free()
	var new_level = load("src/levels/level" + str(current_index) + ".tscn")
	current = new_level.instantiate()
	add_child(current)
	current_index = index
	level_start_time = Time.get_ticks_msec()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not (red_opened and green_opened):
		current_time = Time.get_ticks_msec()
		var ms = current_time - level_start_time
		var sec = floor(ms / 1000)
		var min = floor(sec / 60)
		label.text = "%02d:%02d:%03d" % [min, (sec % 60), (ms % 1000)]

func _on_level_switch_pressed() -> void:
	print("pressed")
	current_index = (current_index + 1) % (max_levels + 1)
	load_level(current_index)
	
func on_door_opened(name) -> void:
	# check sender
	if name == "red_door":
		red_opened = true
	elif name == "green_door":
		green_opened = true
	if red_opened and green_opened:
		timer.start()

func _on_timer_timeout():
	current_index = (current_index + 1) % (max_levels + 1)
	load_level(current_index)
	red_opened = false
	green_opened = false
	green_key.text = "No Green Key"
	red_key.text = "No Red Key"

func _on_exit_pressed() -> void:
	get_tree().quit()
