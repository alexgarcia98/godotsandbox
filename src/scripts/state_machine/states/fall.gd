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
@export
var shoot_state: State
@export
var enter_door_state: State

func process_input(event: InputEvent) -> State:
	super(event)
	#if Input.is_action_just_pressed('switch'):
		#parent.is_main = not parent.is_main
		#parent.indicator.visible = not parent.indicator.visible
		#if parent.is_main:
			#parent.set_z_index(7)
		#else:
			#parent.set_z_index(6)
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
	var movement = get_movement_input() * move_speed

	var norm = parent.get_wall_normal()

	if parent.is_on_wall_only():
		if norm.x * movement < 0:
			return wall_cling_state
	
	parent.velocity.y += gravity * delta
	
	if movement != 0:
		animations.flip_h = movement < 0
	parent.velocity.x = movement
	parent.velocity = gate_check(parent.velocity)
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movement != 0:
			return move_state
		return idle_state
	return null
