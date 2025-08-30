extends State

@export
var idle_state: State
@export
var wall_jump_state: State
@export
var fall_state: State
@export
var ledge_state: State

var print_velocity = true

func enter() -> void:
	super()
	parent.airdash_remaining = parent.max_airdash
	print_velocity = true

func process_input(event: InputEvent) -> State:
	super(event)
	if Input.is_action_just_pressed('jump'):
		if parent.jump_released:
			parent.jump_released = false
			return wall_jump_state
	if Input.is_action_just_pressed('dash'):
		return fall_state
	return null

func process_physics(delta: float) -> State:
	check_stuck()
	var norm = parent.get_wall_normal()
	animations.flip_h = norm.x < 0
	
	if print_velocity:
		print("velocity: " + str(parent.velocity.y))
		print_velocity = false
	# check current y velocity
	if parent.velocity.y <= 49:
		var has_ceiling = parent.ceiling_up_1.is_colliding() or parent.ceiling_up_2.is_colliding() or parent.gate_up_1.is_colliding() or parent.gate_up_2.is_colliding()
		if norm.x > 0:
			if ((not parent.air_left.is_colliding()) or (not parent.air_left_2.is_colliding())) and not has_ceiling:
				print("x15")
				return ledge_state
			else:
				if (not parent.air_left_3.is_colliding()) and (not parent.wall_left.is_colliding()) and not has_ceiling:
					parent.velocity.x = -500
					parent.velocity.y = 49
					parent.move_and_slide()
					print("x17")
					return null

		else:
			if ((not parent.air_right.is_colliding()) or (not parent.air_right_2.is_colliding())) and not has_ceiling:
				print("x16")
				return ledge_state
			else:
				if (not parent.air_right_3.is_colliding()) and (not parent.wall_right.is_colliding()) and not has_ceiling:
					parent.velocity.x = 500
					parent.velocity.y = 49
					parent.move_and_slide()
					print("x18")
					return null

	parent.velocity.y = 50
	parent.velocity.x = 0

	parent.move_and_slide()
	
	if not parent.is_on_wall_only():
		return fall_state
	
	if parent.is_on_floor():
		return idle_state
	return null
