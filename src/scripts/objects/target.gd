extends Area2D

@onready
var objects: Node = get_parent()

@export
var pairing = 0

func activate() -> void:
	Messages.TargetHit.emit()
	objects.queue_free()
