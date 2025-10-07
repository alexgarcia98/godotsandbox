extends AnimatableBody2D

@onready
var objects: Node = get_parent()

var animation_player

@export
var pairing = 0

@export 
var is_visible = true

func _ready() -> void:
	visible = is_visible
	if get_node_or_null("AnimationPlayer"):
		animation_player = $AnimationPlayer
	else:
		animation_player = null
	Messages.connect("BeginLevel", on_begin_level)
	Messages.connect("LightsSwitched", on_switch_toggled)

func on_begin_level(_current_index):
	print("signal received in %s" % name)
	if animation_player != null and is_visible:
		animation_player.play("startup")

func on_switch_toggled(pair):
	if animation_player != null and pairing != pair and is_visible:
		animation_player.play("startup")

func change_state() -> void:
	Messages.LightsSwitched.emit(pairing)
	if animation_player != null and is_visible:
		animation_player.play("turn_on")
		is_visible = false
	elif not is_visible:
		animation_player.play_backwards("turn_on")
		is_visible = true
