extends TileMapLayer
@export var world_number: int
@onready var clear_time: Label = $ClearTime
@onready var clear_rank: Label = $ClearRank
@onready var next: Button = $Control/MarginContainer/HBoxContainer/Next
@onready var stage_select: Button = $Control/MarginContainer/HBoxContainer/StageSelect
@onready var title: Button = $Control/MarginContainer/HBoxContainer/Title
@onready var world_name: Label = $WorldName

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	world_name.text = Messages.worldNames[world_number]
	var clear_time_text = Messages.get_world_time(world_number)
	var rank_text = Messages.get_world_rank(world_number)
	
	if clear_time_text != "":
		clear_time.text = "World Clear Time: " + clear_time_text
	
	if rank_text != "":
		clear_rank.text = "World Rank: " + rank_text
	
	if world_number == 10:
		if Messages.unlocked_levels[Messages.worldNames[11]] == 0:
			next.disabled = true
			stage_select.grab_focus.call_deferred()
		else:
			next.disabled = false
			next.grab_focus.call_deferred()
	elif world_number == 7:
		next.disabled = true
		stage_select.grab_focus.call_deferred()
	elif world_number == 3:
		if Messages.unlocked_levels[Messages.worldNames[7]] == 0:
			next.disabled = true
			stage_select.grab_focus.call_deferred()
		else:
			next.disabled = false
			next.grab_focus.call_deferred()
	else:
		next.disabled = false
		next.grab_focus.call_deferred()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_next_pressed() -> void:
	Messages.audio.stream = Messages.stage_select_pressed_sound
	Messages.audio.play()
	Messages.NextLevel.emit()

func _on_stage_select_pressed() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	Messages.emit_signal("WorldSelect")

func _on_title_pressed() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	Messages.emit_signal("MainMenu")
