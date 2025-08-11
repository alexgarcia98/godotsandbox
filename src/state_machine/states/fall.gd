extends State

@export
var idle_state: State
@export
var move_state: State
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
var jump_state: State
@export
var wall_cling_state: State
@export
var air_pivot_state: State

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('switch'):
		parent.is_main = not parent.is_main
		parent.indicator.visible = not parent.indicator.visible
	if Input.is_action_just_pressed('jump'):
		if parent.jumps_remaining > 0:
			parent.jumps_remaining -= 1
			return jump_state
	if Input.is_action_just_pressed('dash'):
		if parent.airdash_remaining > 0:
			return airdash_state
	if Input.is_action_just_pressed('pivot'):
		if parent.air_reverse_remaining > 0:
			return air_pivot_state
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
	var movement = get_movement_input() * move_speed

	if parent.is_on_wall_only() and movement != 0:
		return wall_cling_state
	
	parent.velocity.y += gravity * delta
	
	if movement != 0:
		animations.flip_h = movement < 0
	parent.velocity.x = movement
	parent.velocity = gate_check(parent.velocity)
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movement != 0:
			print("not falling")
			return move_state
		return idle_state
	return null
