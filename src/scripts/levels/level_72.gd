extends TileMapLayer

signal LevelDone(emitter)
@onready var purple_gate: AnimatableBody2D = $objects/purple_gate
var target_count = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messages.connect("TargetHit", on_target_hit)

func on_target_hit():
	target_count -= 1
	if target_count == 0:
		purple_gate.change_state()
