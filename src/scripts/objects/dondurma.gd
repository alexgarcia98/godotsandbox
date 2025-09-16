extends AnimatableBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ray_3: RayCast2D = $ray3
@onready var ray_4: RayCast2D = $ray4
@onready var ray_2: RayCast2D = $ray2
@onready var ray_1: RayCast2D = $ray1

var right = true
var count = 10
var teleporting = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("RESET")
	teleporting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not teleporting and count > 0:
		if ray_1.is_colliding() or ray_2.is_colliding() or ray_3.is_colliding() or ray_4.is_colliding():
			if right:
				teleporting = true
				animation_player.play("move_left")
				print("teleporting %s" % (10 - count))
			else:
				teleporting = true
				animation_player.play("RESET")
				print("teleporting %s" % (10 - count))
			right = not right
			count -= 1

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	teleporting = false
