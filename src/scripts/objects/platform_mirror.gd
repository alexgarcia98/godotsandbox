extends AnimatableBody2D
@onready var timer: Timer = $Timer

@onready
var objects: Node = get_parent()

var popo_flipped = false

var climber

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	popo_flipped = false
	if name == "mirror_left":
		climber = objects.get_node("Popo")
	elif name == "mirror_right":
		climber = objects.get_node("Nana")

func toggle_popo():
	popo_flipped = not popo_flipped

func on_hammer_fired():
	if not popo_flipped:
		timer.start()

func _on_timer_timeout() -> void:
	climber.platform_gone()
	queue_free()
