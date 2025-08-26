extends AnimatableBody2D

@onready
var objects: Node = get_parent()

@onready var animations: AnimationPlayer = $AnimationPlayer

@export
var pairing = 0

var barcount = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messages.connect("BeginLevel", on_begin_level)
	animations.play("RESET")

func on_begin_level(_current_index):
	print("signal received in %s" % name)
	animations.play("RESET")

func turn_off() -> void:
	barcount += 1
	if barcount == 1:
		animations.play("shot1")
	if barcount == 2:
		animations.play("shot2")
	if barcount == 3:
		animations.play("shot3")
	if barcount == 4:
		animations.play("shot4")
