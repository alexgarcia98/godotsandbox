extends Area2D

signal ButtonPressed(emitter)
signal ButtonOn(emitter)
signal AirmanShot()
signal PopoFace()
signal PopoHammer()
signal NanaFace()
signal NanaHammer()
signal EnemyShot()
signal PopoShot()
signal NanaShot()

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
	elif name.begins_with("boss_popo"):
		var level = objects.get_parent()
		var hp = level.get_node("PopoHP")
		connect("PopoShot", hp.decrease)
		damaged = false
	elif name.begins_with("boss_nana"):
		var level = objects.get_parent()
		var hp = level.get_node("NanaHP")
		connect("NanaShot", hp.decrease)
		damaged = false
	elif name.begins_with("doom"):
		pass
	elif name.begins_with("popo"):
		damaged = false
		if name.begins_with("popo_hammer"):
			var level = objects.get_parent()
			var hammer = level.get_node("hammer")
			connect("PopoHammer", hammer.shoot)
			var platform = level.get_node("popo_platform")
			connect("PopoHammer", platform.on_hammer_fired)
			var platform2 = level.get_node("mirror_left")
			connect("PopoHammer", platform2.on_hammer_fired)
		elif name.begins_with("popo_face"):
			connect("PopoFace", objects.turn_around)
			var level = objects.get_parent()
			var hammer = level.get_node("hammer")
			connect("PopoFace", hammer.set_flipped)
			var platform = level.get_node("popo_platform")
			connect("PopoFace", platform.toggle_popo)
			var platform2 = level.get_node("mirror_left")
			connect("PopoFace", platform2.toggle_popo)
	elif name.begins_with("nana"):
		damaged = false
		if name.begins_with("nana_hammer"):
			var level = objects.get_parent()
			var hammer2 = level.get_node("hammer2")
			connect("NanaHammer", hammer2.shoot)
			var platform = level.get_node("nana_platform")
			connect("NanaHammer", platform.on_hammer_fired)
			var platform2 = level.get_node("mirror_right")
			connect("NanaHammer", platform2.on_hammer_fired)
		elif name.begins_with("nana_face"):
			connect("NanaFace", objects.turn_around)
			var level = objects.get_parent()
			var hammer2 = level.get_node("hammer2")
			connect("NanaFace", hammer2.set_flipped)
			var platform = level.get_node("nana_platform")
			connect("NanaFace", platform.toggle_popo)
			var platform2 = level.get_node("mirror_right")
			connect("NanaFace", platform2.toggle_popo)
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
	elif name.begins_with("boss_popo"):
		if not damaged:
			damaged = true
			animations.play("button_on_off")
			emit_signal("PopoShot")
	elif name.begins_with("boss_nana"):
		if not damaged:
			damaged = true
			animations.play("button_on_off")
			emit_signal("NanaShot")
	elif name.begins_with("doom"):
		objects.queue_free()
	elif name.begins_with("popo_hammer"):
		if not damaged:
			damaged = true
			animations.play("button_on_off")
			emit_signal("PopoHammer")
	elif name.begins_with("popo_face"):
		if not damaged:
			damaged = true
			animations.play("button_on_off")
			emit_signal("PopoFace")
	elif name.begins_with("nana_hammer"):
		if not damaged:
			damaged = true
			animations.play("button_on_off")
			emit_signal("NanaHammer")
	elif name.begins_with("nana_face"):
		if not damaged:
			damaged = true
			animations.play("button_on_off")
			emit_signal("NanaFace")
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
