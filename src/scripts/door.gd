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
	else:
		animations.play_backwards("opening")
		closed = true
		
#
#func _on_animated_sprite_2d_animation_finished() -> void:
	#print(4)
	#if animation_name == "opening":
		#print(5)
		#if opening:
			#print(8)
			#animation_name = "opened"
		#else:
			#print(9)
			#animation_name = "closed"
		#animations.play(animation_name)
