extends AnimatableBody2D

var remaining = 2

@onready
var objects: Node = get_parent()
var hammer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if name == "Popo":
		hammer = objects.get_node("hammer")
	elif name == "Nana":
		hammer = objects.get_node("hammer2")

func turn_around():
	print("turning around")
	scale.x *= -1

func platform_gone():
	remaining -= 1
	if remaining <= 0:
		hammer.despawn()
		queue_free()
