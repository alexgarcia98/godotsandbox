extends Area2D

signal ButtonPressed(emitter)
signal ButtonOn(emitter)
signal AirmanShot()
signal EnemyShot()

@onready
var objects: Node = get_parent()

@export
var pairing = 0

@onready
var animations = $animations

@export
var button_pressed = false

var damaged = false

func _ready() -> void:
	if name.begins_with("airman"):
		var level = objects.get_parent()
		var hp = level.get_node("hp")
		connect("AirmanShot", hp.decrease)
		damaged = false
	elif name.begins_with("doom"):
		pass
	else:
		if button_pressed:
			animations.play("button_on")
		if pairing != 0:
			for object in objects.get_children():
				if object.pairing == pairing and object.name != name:
					if object.name.begins_with("hadouken"):
						connect("ButtonOn", object.change_state)
					elif object.name.begins_with("hp_bar"):
						pass
					else:
						connect("ButtonPressed", object.change_state)


func activate() -> void:
	if name.begins_with("airman"):
		if not damaged:
			damaged = true
			animations.play("button_on_off")
			emit_signal("AirmanShot")
	elif name.begins_with("doom"):
		objects.queue_free()
	else:
		emit_signal("ButtonPressed")
		change_state()
		if button_pressed:
			emit_signal("ButtonOn")
		
func change_state() -> void:
	if button_pressed:
		animations.play_backwards("activate_button")
		button_pressed = false
	else:
		animations.play("activate_button")
		button_pressed = true

func turn_off() -> void:
	if button_pressed:
		animations.play_backwards("activate_button")
		button_pressed = false


func _on_animations_animation_finished() -> void:
	if damaged:
		damaged = false
