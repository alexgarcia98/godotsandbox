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
	super(event)
	#if Input.is_action_just_pressed('switch'):
		#parent.is_main = not parent.is_main
		#parent.indicator.visible = not parent.indicator.visible
		#if parent.is_main:
			#parent.set_z_index(7)
		#else:
			#parent.set_z_index(6)
	if Input.is_action_just_pressed('jump'):
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
		
	parent.velocity = gate_check(parent.velocity)
	parent.move_and_slide()
	
	if not parent.is_on_wall_only():
		parent.velocity.y = 0
		return fall_state
	
	if parent.is_on_floor():
		return idle_state
	return null
