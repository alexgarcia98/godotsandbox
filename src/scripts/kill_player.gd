extends Area2D

var pairing = 0
@onready var timer: Timer = $Timer

var respawn

func _on_body_entered(body):
	body.visible = false
	respawn = body
	timer.start()
	print(body.name + " died")

func _on_timer_timeout():
	respawn.position = respawn.last_valid
	respawn.visible = true
	print(respawn.name + " revived")
