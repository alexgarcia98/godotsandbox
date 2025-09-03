extends AnimatableBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var is_left: bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_left:
		animation_player.play("face_left")
	else:
		animation_player.play("face_right")

func set_flipped():
	if is_left:
		animation_player.play("face_right")
	else:
		animation_player.play("face_left")
	is_left = not is_left

func shoot():
	print("playing hammer animation")
	if is_left:
		animation_player.play("shoot_left")
		animation_player.queue("face_left")
	else:
		animation_player.play("shoot_right")
		animation_player.queue("face_right")

func despawn():
	queue_free()
