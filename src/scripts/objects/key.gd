extends Area2D

@onready
var objects: Node = get_parent()

@export
var pairing = 0
@onready var pickup_sound: AudioStreamPlayer2D = $PickupSound
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@onready
var animations = $animations

func _ready() -> void:
	pickup_sound.stream = Messages.pickup_sound

func activate() -> void:
	collision_shape_2d.set_deferred("disabled", true)
	visible = false
	Messages.KeyObtained.emit(name)
	pickup_sound.play()

func _on_animations_animation_finished() -> void:
	animations.flip_h = not animations.flip_h
	animations.play("idle")

func _on_pickup_sound_finished() -> void:
	queue_free()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass # Replace with function body.
