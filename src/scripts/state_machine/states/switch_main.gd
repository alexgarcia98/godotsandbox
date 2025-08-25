extends State

@export
var idle_state: State
@export
var fall_state: State

func enter() -> void:
	parent.is_main = not parent.is_main
	parent.indicator.visible = not parent.indicator.visible
	if parent.is_main:
		parent.set_z_index(7)
	else:
		parent.set_z_index(6)

	#var switch_animation = "sub_switch"
	#if parent.is_main:
		#switch_animation = "main_switch"
		#
	#animations.play(switch_animation)

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('switch'):
		parent.is_main = not parent.is_main
		parent.indicator.visible = not parent.indicator.visible
	return null

func process_physics(delta: float) -> State:
	#parent.velocity.y += gravity * delta
	#parent.velocity.x = 0
	#parent.velocity = gate_check(parent.velocity)
	#parent.move_and_slide()
	#
	#if !parent.is_on_floor():
		#return fall_state
		#
	#if animations.frame >= 5:
		#return idle_state
	#return null
	parent.velocity.y += (gravity * delta)

	var movement = get_movement_input() * move_speed
	
	if movement == 0:
		return idle_state
	
	animations.flip_h = movement < 0
	parent.velocity.x = movement
	parent.velocity = gate_check(parent.velocity)
	
	if !parent.is_on_floor():
		return fall_state
	return null
