extends TileMapLayer

@onready var play: Button = $Play
@onready var exit: Button = $Exit

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
