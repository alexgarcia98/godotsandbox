extends TileMapLayer

@onready var play: Button = $UI/MarginContainer/HBoxContainer/Play
@onready var reset_times: Button = $UI/MarginContainer/HBoxContainer/ResetTimes
@onready var exit: Button = $UI/MarginContainer/HBoxContainer/Exit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	Messages.emit_signal("WorldSelect")


func _on_exit_pressed() -> void:
	Messages.emit_signal("EndGame")


func _on_reset_times_pressed() -> void:
	Messages.emit_signal("ResetTimes")
