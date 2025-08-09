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

func enter() -> void:
	if parent.is_flipped:
		parent.is_flipped = false
		animations.flip_h = true
	super()
	parent.velocity.x = 0
	parent.jumps_remaining = parent.max_jumps
	parent.airdash_remaining = parent.max_airdash
	parent.air_reverse_remaining = parent.max_air_reverse
	#if parent.visible:
		#parent.last_valid = parent.position

func process_input(event: InputEvent) -> State:
	if get_jump() and parent.is_on_floor():
		parent.last_valid = parent.position
		return jump_state
	if get_movement_input() != 0.0:
		parent.last_valid = parent.position
		return move_state
	if Input.is_action_just_pressed('dash'):
		parent.last_valid = parent.position
		return dash_state
	if Input.is_action_just_pressed('pivot'):
		return pivot_state
	#if Input.is_action_just_pressed('debug_single_pivot'):
		#return single_pivot_state
	if Input.is_action_just_pressed('switch'):
		return switch_state
	if Input.is_action_just_pressed('action'):
		# check direction
		var horiz = Input.get_axis('move_left', 'move_right')
		var vert = Input.get_axis('move_down', 'move_up')
		if vert < 0:
			return frozen_state
		else:
			if horiz == 0 && vert == 0:
				return interact_state
			# check for closeness
			if parent.throwable:
				if parent.is_main:
					return throw_state
				else:
					return thrown_state
			
		
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null
