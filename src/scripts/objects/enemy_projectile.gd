extends AnimatableBody2D

var pairing = 0
@onready var red_timer: Timer = $red_timer
@onready var green_timer: Timer = $green_timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var respawn_red
var respawn_green

func activate() -> void:
	pass

func _ready() -> void:
	Messages.connect("BeginLevel", on_begin_level)

func on_begin_level(_current_index):
	print("signal received in %s" % name)
	animation_player.play("move")

func _on_red_timer_timeout() -> void:
	respawn_red.position = respawn_red.last_valid
	respawn_red.is_flipped = respawn_red.last_facing
	respawn_red.flip_toggled = false
	respawn_red.visible = true
	respawn_red.collision_shape_2d.set_deferred("disabled", false)
	print(respawn_red.name + " revived")
	Messages.PlayerRevived.emit(respawn_red.name)

func _on_green_timer_timeout() -> void:
	respawn_green.position = respawn_green.last_valid
	respawn_green.is_flipped = respawn_green.last_facing
	respawn_green.flip_toggled = false
	respawn_green.visible = true
	respawn_green.collision_shape_2d.set_deferred("disabled", false)
	print(respawn_green.name + " revived")
	Messages.PlayerRevived.emit(respawn_green.name)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.visible and body.can_move:
		body.visible = false
		body.collision_shape_2d.set_deferred("disabled", true)
		Messages.PlayerDied.emit(body)
		print(body.name + " died")
		body.sfx.stream = Messages.die_sound
		body.sfx.play()
		if body.name == "red_player":
			respawn_red = body
			red_timer.start()
		elif body.name == "green_player":
			respawn_green = body
			green_timer.start()
