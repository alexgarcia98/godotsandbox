extends AnimatableBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func deplete():
	animation_player.play("deplete")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
