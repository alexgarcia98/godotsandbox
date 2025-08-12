extends State

@export
var idle_state: State
@export
var wall_jump_state: State
@export
var fall_state: State
@export
var ledge_state: State

func enter() -> void:
	super()
	parent.airdash_remaining = parent.max_airdash

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('switch'):
		parent.is_main = not parent.is_main
		parent.indicator.visible = not parent.indicator.visible
	if Input.is_action_just_pressed('jump'):
		return wall_jump_state
	if Input.is_action_just_pressed('move_down'):
		return fall_state
	return null

func process_physics(delta: float) -> State:	
	var norm = parent.get_wall_normal()
	animations.flip_h = norm.x < 0
	
	# check current y velocity
	if parent.velocity.y <= 49:
		if norm.x > 0:
			if not parent.air_left.is_colliding():
				#print(parent.name + ": wall_left: " + str(parent.wall_left.is_colliding()))
				#print(parent.name + ": air_left: " + str(parent.air_left.is_colliding()))
				return ledge_state
		else:
			if not parent.air_right.is_colliding():
				#print(parent.name + ": wall_right: " + str(parent.wall_right.is_colliding()))
				#print(parent.name + ": air_right: " + str(parent.air_right.is_colliding()))
				return ledge_state

	parent.velocity.y = 50
	parent.velocity.x = 0

	parent.move_and_slide()
	
	if not parent.is_on_wall_only():
		return fall_state
	
	if parent.is_on_floor():
		return idle_state
	return null
