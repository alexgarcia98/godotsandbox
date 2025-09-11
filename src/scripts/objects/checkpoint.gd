extends Node2D

@onready var red: RayCast2D = $RayCast2D
@onready var green: RayCast2D = $RayCast2D2

var green_entered = false
var red_entered = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	green_entered = false
	red_entered = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if red.is_colliding():
		if not red_entered:
			red_entered = true
			var player = red.get_collider()
			var pos = global_position
			pos.y -= 17
			Messages.emit_signal("SetRedPlayerRespawn", pos)
			print("emit signal 1")
			#player.set_respawn(pos, false)
	else:
		red_entered = false
	if green.is_colliding():
		if not green_entered:
			green_entered = true
			var player = green.get_collider()
			var pos = global_position
			pos.y -= 17
			Messages.emit_signal("SetGreenPlayerRespawn", pos)
			print("emit signal 2")
			#player.set_respawn(pos, false)
	else:
		green_entered = false
