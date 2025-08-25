extends Area2D

var pairing = 0
@onready var red_timer: Timer = $red_timer
@onready var green_timer: Timer = $green_timer
@onready var red_timer_2: Timer = $red_timer2
@onready var green_timer_2: Timer = $green_timer2

var respawn_red
var respawn_green

var temp_red
var temp_green

func activate() -> void:
	pass

func _on_body_entered(body):
	if body.visible and body.can_move:
		if body.can_die:
			body.visible = false
			body.collision_shape_2d.set_deferred("disabled", true)
			Messages.PlayerDied.emit(body)
			print(body.name + " died")
			body.sfx.stream = Messages.die_sound
			body.sfx.play()
			body.can_die = false
			if body.name == "red_player":
				respawn_red = body
				red_timer.start()
				red_timer_2.start()
			elif body.name == "green_player":
				respawn_green = body
				green_timer.start()
				green_timer_2.start()
		else:
			if body.name == "red_player":
				temp_red = body
			elif body.name == "green_player":
				temp_green = body

func _on_body_exited(body: Node2D) -> void:
	if body.name == "red_player":
		if temp_red:
			temp_red = null
	if body.name == "green_player":
		if temp_green:
			temp_green = null

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


func _on_red_timer_2_timeout() -> void:
	if temp_red:
		temp_red.visible = false
		temp_red.collision_shape_2d.set_deferred("disabled", true)
		Messages.PlayerDied.emit(temp_red)
		print(temp_red.name + " died")
		temp_red.sfx.stream = Messages.die_sound
		temp_red.sfx.play()
		red_timer.start()
		red_timer_2.start()
	else:
		Messages.PlayerVulnerable.emit("red_player")


func _on_green_timer_2_timeout() -> void:
	if temp_green:
		temp_green.visible = false
		temp_green.collision_shape_2d.set_deferred("disabled", true)
		Messages.PlayerDied.emit(temp_green)
		print(temp_green.name + " died")
		temp_green.sfx.stream = Messages.die_sound
		temp_green.sfx.play()
		green_timer.start()
		green_timer_2.start()
	else:
		Messages.PlayerVulnerable.emit("green_player")
