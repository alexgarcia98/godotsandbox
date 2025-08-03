extends State

@export
var idle_state: State
@export
var wall_jump_state: State
@export
var fall_state: State

func enter() -> void:
	super()
	parent.airdash_remaining = parent.max_airdash

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('switch'):
		parent.is_main = not parent.is_main
	if Input.is_action_just_pressed('jump'):
		return wall_jump_state
	if Input.is_action_just_pressed('move_down'):
		return fall_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y = 30
	parent.velocity.x = 0
	
	var norm = parent.get_wall_normal()
	animations.flip_h = norm.x < 0

	parent.move_and_slide()
	
	if not parent.is_on_wall_only():
		return fall_state
	
	if parent.is_on_floor():
		return idle_state
	return null
