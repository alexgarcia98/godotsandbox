extends TileMapLayer

@onready var clear_time: Label = $ClearTime
@onready var title: Button = $Control/MarginContainer/HBoxContainer/Title
@onready var stage_select: Button = $Control/MarginContainer/HBoxContainer/StageSelect
@onready var exit: Button = $Control/MarginContainer/HBoxContainer/Exit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_clear_time()
	title.grab_focus.call_deferred()

func set_clear_time():
	var total_time : int = 0
	var all_cleared : bool = true
	for i in range(Messages.max_levels + 1):
		var level = Messages.get_stored_level_time(i)
		if level == 5999999:
			all_cleared = false
			break
		total_time += level
	if all_cleared:
		var sec = floor(total_time / 1000)
		var minute = floor(sec / 60)
		var hour = floor(minute / 60)
		clear_time.text = "Total Clear Time: %02d:%02d:%02d.%03d" % [
			hour, (minute % 60), (sec % 60), (total_time % 1000)
		]
	else:
		clear_time.text = "Clear all levels to obtain a total clear time!"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_title_pressed() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	Messages.emit_signal("MainMenu")

func _on_stage_select_pressed() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	Messages.emit_signal("WorldSelect")

func _on_exit_pressed() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	Messages.emit_signal("EndGame")
