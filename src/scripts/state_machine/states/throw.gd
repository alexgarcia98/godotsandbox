extends State

@export
var idle_state: State
@export
var fall_state: State
@export
var move_state: State

func enter() -> void:
	var horiz = Input.get_axis('move_left', 'move_right')
	if horiz < 0:
		animation_name = "throw_left"
		animations.flip_h = true
	elif horiz > 0:
		animation_name = "throw_right"
	else:
		animation_name = "throw_up"
	animations.play(animation_name)
	parent.sfx.stream = Messages.throw_sound
	parent.sfx.play()

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
	parent.velocity.y += gravity * delta
	parent.velocity.x = 0
	parent.velocity = gate_check(parent.velocity)
	parent.move_and_slide()
	
	if animations.frame >= 5:
		if !parent.is_on_floor():
			return fall_state
		if get_movement_input() != 0.0:
			return move_state
		if get_advancement_input() != 0.0:
			return move_state
		return idle_state
	return null
