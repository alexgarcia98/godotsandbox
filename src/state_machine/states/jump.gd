extends State

@export
var fall_state: State
@export
var jump_state: State
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
var wall_cling_state: State

@export
var jump_force: float = 400

func enter() -> void:
	super()
	parent.velocity.y = -jump_force
	parent.jumps_remaining -= 1

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('switch'):
		parent.is_main = not parent.is_main
		parent.indicator.visible = not parent.indicator.visible
	if Input.is_action_just_pressed('jump'):
		if parent.jumps_remaining > 0:
			return jump_state
	if Input.is_action_just_pressed('dash'):
		if parent.airdash_remaining > 0:
			return airdash_state
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
	var movement = get_movement_input() * move_speed

	if parent.is_on_wall_only() and movement != 0:
		return wall_cling_state
	
	parent.velocity.y += gravity * delta
	
	if parent.velocity.y > 0:
		return fall_state
	
	if movement != 0:
		animations.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movement != 0:
			return move_state
		return idle_state
	
	return null
