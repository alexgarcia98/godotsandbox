extends State

@export
var idle_state: State

@export
var fall_state: State

var flipped = false

func enter() -> void:
	super()
	parent.velocity.x = 0
	parent.air_reverse_remaining -= 1

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('switch'):
		parent.is_main = not parent.is_main
		parent.indicator.visible = not parent.indicator.visible
	return null

func process_physics(delta: float) -> State:
	if animations.frame > 2 and not flipped:
		animations.flip_h = not animations.flip_h
		flipped = true
	parent.velocity.y = 0
	parent.velocity = gate_check(parent.velocity)
	parent.move_and_slide()
	
	if animations.frame >= 5:
		flipped = false
		if !parent.is_on_floor():
			return fall_state
		return idle_state
	return null
