extends State

@export
var idle_state: State
@export
var wall_jump_state: State
@export
var fall_state: State
@export
var wall_cling_state: State

var head_exposed = false

func enter() -> void:
	super()
	parent.last_position = parent.position
	parent.stuck_count = 0
	parent.airdash_remaining = parent.max_airdash
	var norm = parent.get_wall_normal()
	if norm.x > 0:
		if parent.air_left_2.is_colliding():
			head_exposed = false
			print("%s: x12" % parent.name)
		else:
			head_exposed = true
			print("%s: x2" % parent.name)
	else:
		if parent.air_right_2.is_colliding():
			head_exposed = false
			print("%s: x32" % parent.name)
		else:
			head_exposed = true
			print("%s: x4" % parent.name)

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
	check_stuck()
	parent.velocity.y = -150
	parent.velocity.x = 500
	
	var norm = parent.get_wall_normal()
	if norm.x > 0:
		parent.velocity.x *= -1
		animations.flip_h = true
	else:
		animations.flip_h = false

	var has_ceiling = parent.ceiling_up_1.is_colliding() or parent.ceiling_up_2.is_colliding() or parent.gate_up_1.is_colliding() or parent.gate_up_2.is_colliding()
	var has_floor = parent.floor_down_3.is_colliding() or parent.floor_down_4.is_colliding()
	if norm.x > 0:
		if head_exposed:
			if parent.air_left_2.is_colliding():
				print("%s: 1" % parent.name)
				parent.velocity.y = 0
				parent.move_and_slide()
				return wall_cling_state
			else:
				if (not parent.wall_left.is_colliding()) and (not parent.air_left_3.is_colliding()):
					parent.velocity.y = 49
					print("%s: x14" % parent.name)
				else:
					print("%s: x7" % parent.name)
		else:
			if not parent.air_left_2.is_colliding():
				print("%s: x5" % parent.name)
				head_exposed = true
			else:
				print("%s: x8" % parent.name)
	else:
		if head_exposed:
			if parent.air_right_2.is_colliding():
				print("2" % parent.name)
				parent.velocity.y = 0
				parent.move_and_slide()
				return wall_cling_state
			else:
				if (not parent.wall_right.is_colliding()) and (not parent.air_right_3.is_colliding()):
					parent.velocity.y = 49
					print("%s: x13" % parent.name)
				else:
					print("%s: x9" % parent.name)
		else:
			if not parent.air_right_2.is_colliding():
				print("%s: x6" % parent.name)
				head_exposed = true
			else:
				print("%s: x10" % parent.name)
		
		
	parent.velocity = gate_check(parent.velocity)
	
	if not parent.is_on_wall_only():
		parent.velocity.y = 0
		if (not has_floor) and has_ceiling:
			parent.velocity.x = parent.velocity.x / 2
			#if norm.x > 0:
				#parent.velocity.x = -250
			#else:
				#parent.velocity.x = 250
			parent.move_and_slide()
			print("%s: x51" % parent.name)
		else:
			print("%s: x50" % parent.name)
		return fall_state
	
	if parent.is_on_floor():
		return idle_state
	return null
