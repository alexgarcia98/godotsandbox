extends AnimatableBody2D

@onready
var objects: Node = get_parent()

@onready var animations: AnimationPlayer = $BlockAnimation

@export
var pairing = 0

var played = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messages.connect("BeginLevel", on_begin_level)
	animations.play("move")

func on_begin_level(_current_index):
	print("signal received in %s" % name)
	animations.play("move")

func change_state() -> void:
	if not played:
		played = true
		animations.play("destroy")
		animations.queue("done")
