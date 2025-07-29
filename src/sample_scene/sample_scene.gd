extends Node2D

var current = null
var max_levels = 2
var current_index = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level(current_index)

func load_level(index):
	if current:
		current.queue_free()
	var new_level = load("src/levels/level" + str(current_index) + ".tscn")
	current = new_level.instantiate()
	add_child(current)
	current_index = index

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_level_switch_pressed() -> void:
	print("pressed")
	current_index = (current_index + 1) % (max_levels + 1)
	load_level(current_index)

func _on_exit_pressed() -> void:
	get_tree().quit()
