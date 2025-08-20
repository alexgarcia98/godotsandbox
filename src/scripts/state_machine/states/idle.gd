extends State

@export
var dash_state: State
@export
var fall_state: State
@export
var jump_state: State
@export
var move_state: State
@export
var pivot_state: State
@export
var single_pivot_state: State
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
@export
var shoot_state: State
@export
var enter_door_state: State

func enter() -> void:
	if not parent.flip_toggled:
		parent.flip_toggled = true
		if parent.is_flipped:
			parent.is_flipped = false
			animations.flip_h = true
		else:
			animations.flip_h = false
	super()
	parent.velocity.x = 0
	parent.jumps_remaining = parent.max_jumps
	parent.airdash_remaining = parent.max_airdash
	parent.air_reverse_remaining = parent.max_air_reverse
	#if parent.visible:
		#parent.last_valid = parent.position

func process_input(event: InputEvent) -> State:
	super(event)
	if parent.visible:
		parent.last_valid = parent.position
		parent.last_facing = animations.flip_h
	if get_jump() and parent.is_on_floor():
		return jump_state
	if get_movement_input() != 0.0:
		return move_state
	if Input.is_action_just_pressed('dash'):
		return dash_state
	if Input.is_action_just_pressed('pivot'):
		return pivot_state
	#if Input.is_action_just_pressed('debug_single_pivot'):
		#return single_pivot_state
	#if Input.is_action_just_pressed('switch'):
		#parent.is_main = not parent.is_main
		#parent.indicator.visible = not parent.indicator.visible
		#if parent.is_main:
			#parent.set_z_index(7)
		#else:
			#parent.set_z_index(6)
		#return null
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
	if Input.is_action_just_pressed('shoot'):
		if parent.is_main:
			if parent.ammo > 0:
				return shoot_state
	if Input.is_action_just_pressed('move_up'):
		# check for nearby door
		if parent.door != null and parent.key_obtained:
			return enter_door_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.velocity.x = 0
	parent.velocity = gate_check(parent.velocity)
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null
