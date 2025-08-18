extends Button

class_name WorldSelectButton
@export var level: int

func _pressed() -> void:
	Messages.audio.stream = Messages.stage_select_pressed_sound
	Messages.audio.play()
	Messages.LoadWorld.emit(level)
	self.release_focus()
