extends State

@export
var idle_state: State

@export
var fall_state: State

@export
var pivot_state: State

var flipped = false

func enter() -> void:
	super()
	parent.velocity.x = 0

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('switch'):
		parent.is_main = not parent.is_main
	return null

func process_physics(delta: float) -> State:
	if animations.frame > 4 and not flipped:
		animations.flip_h = not animations.flip_h
		flipped = true
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	
	if animations.frame >= 9:
		flipped = false
		return idle_state
	return null
