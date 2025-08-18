extends Button

class_name LevelSelectButton
@export var level: int

func _ready() -> void:
	self.text = str(level + 1)

func _pressed() -> void:
	Messages.audio.stream = Messages.stage_select_pressed_sound
	Messages.audio.play()
	Messages.LoadLevel.emit(level)
	self.release_focus()
