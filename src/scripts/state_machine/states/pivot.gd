extends State

@export
var idle_state: State

@export
var fall_state: State

@export
var dash_state: State

@export
var jump_state: State

var flipped = false

func enter() -> void:
	super()
	flipped = false
	parent.sfx.stream = Messages.pivot_sound
	parent.sfx.play()
	parent.velocity.x = 0

func process_input(event: InputEvent) -> State:
	super(event)
	if Input.is_action_just_pressed('dash'):
		if animations.frame > 2 and flipped:
			return dash_state
		elif animations.frame >= 5:
			return dash_state
	if Input.is_action_just_pressed('jump'):
		if animations.frame > 2 and flipped:
			return jump_state
		elif animations.frame >= 5:
			return jump_state
	return null

func process_physics(delta: float) -> State:
	check_stuck()
	if animations.frame > 2 and not flipped:
		animations.flip_h = not animations.flip_h
		flipped = true
	parent.velocity.y += gravity * delta
	parent.velocity = gate_check(parent.velocity)
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	
	if animations.frame >= 5:
		flipped = false
		return idle_state
	return null
