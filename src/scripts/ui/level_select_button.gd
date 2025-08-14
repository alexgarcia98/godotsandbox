extends Button

class_name LevelSelectButton
@export var level: int

func _ready() -> void:
	self.text = str(level + 1)

func _pressed() -> void:
	Messages.LoadLevel.emit(level)
	self.release_focus()
