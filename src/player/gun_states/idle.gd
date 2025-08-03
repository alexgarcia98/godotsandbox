extends State

@export
var firing_state: State

var indicator = ["fire", "idle"]
var indicator_index = 0

func enter() -> void:
	animations.rotate(deg_to_rad(-90))
	if not parent.is_main:
		animations.play("fire")
		indicator_index = 0
	else:
		animations.play("idle")
		indicator_index = 1

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('switch'):
		print(parent.name + ": switching indicator")
		indicator_index = (indicator_index + 1) % 2
		animations.play(indicator[indicator_index])
		print("playing " + indicator[indicator_index])
	return null

func process_frame(delta: float) -> State:
	return null
