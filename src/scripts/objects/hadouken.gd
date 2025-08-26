extends AnimatableBody2D

signal ShotEnded(emitter)

@onready
var objects: Node = get_parent()

@onready var animations: AnimationPlayer = $AnimationPlayer

@export
var pairing = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messages.connect("BeginLevel", on_begin_level)
	animations.play("move")
	if pairing != 0:
		for object in objects.get_children():
			if object.pairing != 0:
				if (object.pairing == pairing) and (object.name != name):
					connect("ShotEnded", object.turn_off)

func on_begin_level(_current_index):
	print("signal received in %s" % name)
	animations.play("RESET")
		
func change_state() -> void:
	animations.play("fire")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	emit_signal("ShotEnded")
	animations.play("move")
