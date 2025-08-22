extends AnimatableBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messages.connect("BeginLevel", on_begin_level)

func on_begin_level(_current_index):
	print("signal received in platform")
	animation_player.play("move")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
