extends State

@export
var idle_state: State
@export
var wall_jump_state: State
@export
var fall_state: State
@export
var wall_cling_state: State

func enter() -> void:
	super()
	parent.airdash_remaining = parent.max_airdash

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
		parent.velocity.y = 0
		parent.velocity.x = 0
		return wall_jump_state
	if Input.is_action_just_pressed('move_down'):
		return fall_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y = -150
	parent.velocity.x = 500
	
	var norm = parent.get_wall_normal()
	if norm.x > 0:
		parent.velocity.x *= -1
		animations.flip_h = true
	else:
		animations.flip_h = false

	var has_ceiling = parent.ceiling_up_1.is_colliding() or parent.ceiling_up_2.is_colliding() or parent.gate_up_1.is_colliding() or parent.gate_up_2.is_colliding()
	if norm.x > 0:
		if parent.air_left.is_colliding():
			print("1")
			parent.velocity.y = 50
			parent.velocity.x = 0
			parent.velocity = gate_check(parent.velocity)
			parent.move_and_slide()
			return wall_cling_state
	else:
		if parent.air_right.is_colliding():
			print("2")
			parent.velocity.y = 50
			parent.velocity.x = 0
			parent.velocity = gate_check(parent.velocity)
			parent.move_and_slide()
			return wall_cling_state
		
		
	parent.velocity = gate_check(parent.velocity)
	parent.move_and_slide()
	
	if not parent.is_on_wall_only():
		parent.velocity.y = 0
		return fall_state
	
	if parent.is_on_floor():
		return idle_state
	return null
