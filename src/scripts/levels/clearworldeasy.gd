extends TileMapLayer
@export var world_number: int
@onready var world_name: Label = $WorldName
@onready var next_world: Button = $Control/MarginContainer/VBoxContainer/HBoxContainer/NextWorld
@onready var next: Button = $Control/MarginContainer/VBoxContainer/HBoxContainer/Next
@onready var stage_select: Button = $Control/MarginContainer/VBoxContainer/HBoxContainer2/StageSelect
@onready var title: Button = $Control/MarginContainer/VBoxContainer/HBoxContainer2/Title

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	world_name.text = Messages.worldNames[world_number]
	if world_number == 10:
		if Messages.unlocked_levels[Messages.worldNames[11]] == 0:
			next_world.disabled = true
			stage_select.grab_focus.call_deferred()
		else:
			next_world.disabled = false
	else:
		next_world.disabled = false
		next_world.grab_focus.call_deferred()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_next_pressed() -> void:
	Messages.audio.stream = Messages.stage_select_pressed_sound
	Messages.audio.play()
	Messages.NextLevel.emit()

func _on_next_world_pressed() -> void:
	Messages.audio.stream = Messages.stage_select_pressed_sound
	Messages.audio.play()
	Messages.NextWorld.emit()

func _on_stage_select_pressed() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	Messages.emit_signal("WorldSelect")

func _on_title_pressed() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	Messages.emit_signal("MainMenu")
