extends State

@export
var dash_state: State
@export
var fall_state: State
@export
var idle_state: State
@export
var jump_state: State
@export
var airdash_state: State
@export
var interact_state: State
@export
var throw_state: State
@export
var thrown_state: State
@export
var frozen_state: State
@export
var switch_state: State

func enter() -> void:
	super()
	parent.jumps_remaining = parent.max_jumps
	parent.airdash_remaining = parent.max_airdash
	parent.air_reverse_remaining = parent.max_air_reverse

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('jump'):
		if parent.jumps_remaining > 0:
			# set current position
			print("updating position 3")
			parent.last_valid = parent.position
			return jump_state
	if Input.is_action_just_pressed('dash'):
		if parent.is_on_floor():
			print("updating position 1")
			parent.last_valid = parent.position
			return dash_state
		else:
			if parent.airdash_remaining > 0:
				return airdash_state
	if Input.is_action_just_pressed('switch'):
		return switch_state
	if Input.is_action_just_pressed('action'):
		if parent.is_main:
			return interact_state
	if Input.is_action_just_pressed("freeze"):
		if parent.is_main:
			return frozen_state
	if Input.is_action_just_pressed("throw"):
		# check for closeness
		if parent.throwable:
			if parent.is_main:
				return throw_state
			else:
				return thrown_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += (gravity * delta)

	var movement = get_movement_input() * move_speed
	
	if movement == 0:
		return idle_state
	
	animations.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null
