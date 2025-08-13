extends Area2D

signal LeverPulled(emitter)

@onready
var objects: Node = get_parent()

@export
var pairing = 0

@onready
var animations = $animations

@export
var lever_pulled = false

func _ready() -> void:
	if lever_pulled:
		animations.play("lever_on")
	else:
		animations.play("lever_off")
	if pairing != 0:
		for object in objects.get_children():
			if object.pairing != 0:
				if ((object.pairing % 2) == (pairing % 2)) and object.name != name:
					connect("LeverPulled", object.change_state)

func activate() -> void:
	emit_signal("LeverPulled")
	change_state()
	
func change_state() -> void:
	if lever_pulled:
		animations.play_backwards("activate_lever")
		lever_pulled = false
	else:
		animations.play("activate_lever")
		lever_pulled = true
