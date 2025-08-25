extends State

@export
var idle_state: State

@export
var fall_state: State

@export
var single_pivot_state: State

var flipped = false

func enter() -> void:
	if parent.is_main:
		super()
	parent.velocity.x = 0

#func process_input(event: InputEvent) -> State:
	#if Input.is_action_just_pressed('switch'):
		#parent.is_main = not parent.is_main
		#parent.indicator.visible = not parent.indicator.visible
		#if parent.is_main:
			#parent.set_z_index(7)
		#else:
			#parent.set_z_index(6)
	#return null

func process_physics(delta: float) -> State:
	check_stuck()
	if not parent.is_main:
		return idle_state
	if animations.frame > 4 and not flipped:
		animations.flip_h = not animations.flip_h
		flipped = true
	parent.velocity.y += gravity * delta
	parent.velocity = gate_check(parent.velocity)
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	
	if animations.frame >= 9:
		flipped = false
		return idle_state
	return single_pivot_state
