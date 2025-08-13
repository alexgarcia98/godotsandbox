extends AnimatableBody2D

@onready
var objects: Node = get_parent()

@export
var pairing = 0

@onready var animations: AnimationPlayer = $AnimationPlayer

@export
var animation_name = 'RESET'

var closed = true

func _ready() -> void:
	animations.play(animation_name)
	if animation_name == "opened":
		closed = false

func change_state() -> void:
	if closed:
		animations.play("open")
		closed = false
	else:
		animations.play_backwards("open")
		closed = true
