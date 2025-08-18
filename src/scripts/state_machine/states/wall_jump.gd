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
	parent.sfx.stream = Messages.jump_sound
	parent.sfx.play()

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
	parent.velocity.y += gravity * delta
	
	if parent.velocity.y > 0:
		if parent.is_on_wall_only():
			return wall_cling_state
		return fall_state
	
	var movement = move_speed * parent.get_wall_normal().x
	
	if parent.get_slide_collision_count() > 1:
		return wall_cling_state
		
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
