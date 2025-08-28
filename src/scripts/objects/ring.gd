extends Area2D

@onready
var objects: Node = get_parent()

@export
var pairing = 0
@onready var pickup_sound: AudioStreamPlayer2D = $PickupSound
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	pickup_sound.stream = Messages.ring_sound

func activate() -> void:
	collision_shape_2d.set_deferred("disabled", true)
	visible = false
	pickup_sound.play()

func _on_pickup_sound_finished() -> void:
	queue_free()
