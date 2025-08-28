extends AnimatableBody2D

var shot_count = 0

@onready var tornado: AnimatableBody2D = $"../Tornado"
@onready var tornado_2: AnimatableBody2D = $"../Tornado2"
@onready var tornado_3: AnimatableBody2D = $"../Tornado3"
@onready var tornado_4: AnimatableBody2D = $"../Tornado4"
@onready var tornado_5: AnimatableBody2D = $"../Tornado5"
@onready var tornado_6: AnimatableBody2D = $"../Tornado6"
@onready var airman: AnimatableBody2D = $"../airman"
@onready var green_gate: AnimatableBody2D = $"../objects/green_gate"

func decrease():
	shot_count += 1
	if shot_count <= 14:
		var hpbar = get_node("HP%s" % shot_count)
		hpbar.visible = false
	if shot_count == 14:
		stop_system()

func stop_system():
	airman.visible = false
	airman.position.y += 1000
	tornado.play_animation("stop")
	tornado_2.play_animation("stop")
	tornado_3.play_animation("stop")
	tornado_4.play_animation("stop")
	tornado_5.play_animation("stop")
	tornado_6.play_animation("stop")
	green_gate.change_state()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
