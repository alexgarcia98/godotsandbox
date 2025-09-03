extends AnimatableBody2D

@export
var pairing = 0

@onready
var objects: Node = get_parent()

func change_state() -> void:
	queue_free()
