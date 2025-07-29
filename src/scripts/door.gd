extends Area2D

@onready
var objects: Node = get_parent()

@export
var pairing = 0

@onready
var animations = $animations

@onready
var animation_name = 'closed'

var closed = true

func _ready() -> void:
	animations.play(animation_name)

func change_state() -> void:
	if closed:
		animations.play("opening")
		closed = false
		# send signal
		Messages.DoorOpened.emit(name)
	else:
		animations.play_backwards("opening")
		closed = true
