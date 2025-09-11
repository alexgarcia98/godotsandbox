# You could also declare a class_name for the move state
# so you don't have to reference the script directly
extends State

@export
var wall_cling_state: State
@export
var fall_state: State
@export
var jump_state: State
@export
var enter_door_state: State

@export
var time_to_dash := 0.25

var dash_timer := 0.0
var direction := 1.0

func enter() -> void:
	animations.play(animation_name)
	parent.airdash_remaining -= 1
	print(parent.name + " airdash remaining: " + str(parent.airdash_remaining))
	dash_timer = time_to_dash
	parent.currently_flipped = animations.flip_h
	# Simple check for which direction to dash towards
	if animations.flip_h:
		direction = -1
	else:
		direction = 1
	parent.sfx.stream = Messages.airdash_sound
	parent.sfx.play()

## Just to be safe, disable any other inputs
func process_input(event: InputEvent) -> State:
	return super(event)
	if Input.is_action_just_pressed('move_up'):
		# check for nearby door
		if parent.door != null and parent.key_obtained:
			return enter_door_state
	if Input.is_action_just_pressed('jump'):
		if parent.jump_released:
			if parent.jumps_remaining > 0:
				parent.jumps_remaining -= 1
				parent.jump_released = false
				return jump_state
	return null

func process_physics(delta: float) -> State:
	check_stuck()
	parent.velocity.y = 0
	dash_timer -= delta
	if dash_timer <= 0.0:
		# Fall back on the default input implementation to
		# determine where to go next
		if parent.is_on_wall_only():
			return wall_cling_state
		return fall_state

	var movement = get_movement_input() * move_speed
	
	animations.flip_h = movement < 0
	parent.velocity.x = movement
	parent.velocity = gate_check(parent.velocity)
	parent.move_and_slide()

	return null

# Override movement inputs
func get_movement_input() -> float:
	return direction

func get_jump() -> bool:
	return false
