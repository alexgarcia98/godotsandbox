extends State

@export
var idle_state: State
@export
var fall_state: State
@export
var move_state: State

func enter() -> void:
	var horiz = Input.get_axis('move_left', 'move_right')
	var vert = Input.get_axis('move_down', 'move_up')
	if horiz < 0:
		animation_name = "throw_left"
		animations.flip_h = true
	elif horiz > 0:
		animation_name = "throw_right"
	else:
		animation_name = "throw_up"
	animations.play(animation_name)

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('switch'):
		parent.is_main = not parent.is_main
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.velocity.x = 0
	parent.move_and_slide()
	
	if animations.frame >= 5:
		if !parent.is_on_floor():
			return fall_state
		if get_movement_input() != 0.0:
			return move_state
		return idle_state
	return null
