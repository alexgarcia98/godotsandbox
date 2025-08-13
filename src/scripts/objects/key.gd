extends Area2D

@onready
var objects: Node = get_parent()

@export
var pairing = 0

@onready
var animations = $animations

func activate() -> void:
	Messages.KeyObtained.emit(name)
	queue_free()

func _on_animations_animation_finished() -> void:
	animations.flip_h = not animations.flip_h
	animations.play("idle")
