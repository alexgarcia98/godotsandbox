extends AnimatableBody2D

var animation_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_node_or_null("AnimationPlayer"):
		animation_player = $AnimationPlayer
	else:
		animation_player = null
	Messages.connect("BeginLevel", on_begin_level)

func on_begin_level(_current_index):
	print("signal received in %s" % name)
	if animation_player != null:
		animation_player.play("move")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func move():
	if animation_player != null:
		animation_player.play("move")
