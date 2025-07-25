extends Area2D

signal ButtonPressed(emitter)

@onready
var objects: Node = get_parent()

@export
var pairing = 0

@onready
var animations = $animations

var button_pressed = false

func _ready() -> void:
	if pairing != 0:
		for object in objects.get_children():
			if object.pairing == pairing and object.name != name:
				connect("ButtonPressed", object.change_state)

func activate() -> void:
	emit_signal("ButtonPressed")
	if button_pressed:
		animations.play_backwards("activate_button")
		button_pressed = false
	else:
		animations.play("activate_button")
		button_pressed = true
	
