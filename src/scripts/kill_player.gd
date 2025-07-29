extends Area2D

var pairing = 0
@onready var red_timer: Timer = $red_timer
@onready var green_timer: Timer = $green_timer

var respawn_red
var respawn_green

func _on_body_entered(body):
	body.visible = false
	print(body.name + " died")
	if body.name == "red_player":
		respawn_red = body
		red_timer.start()
	elif body.name == "green_player":
		respawn_green = body
		green_timer.start()

func _on_red_timer_timeout() -> void:
	respawn_red.position = respawn_red.last_valid
	respawn_red.visible = true
	print(respawn_red.name + " revived")

func _on_green_timer_timeout() -> void:
	respawn_green.position = respawn_green.last_valid
	respawn_green.visible = true
	print(respawn_green.name + " revived")
