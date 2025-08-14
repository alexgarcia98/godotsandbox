extends Button

class_name WorldSelectButton
@export var level: int

func _pressed() -> void:
	Messages.LoadWorld.emit(level)
	self.release_focus()
