# You could also declare a class_name for the move state
# so you don't have to reference the script directly
extends 'res://src/state_machine/states/move.gd'

@export
var move_state: State

@export
var time_to_dash := 0.25

var dash_timer := 0.0
var direction := 1.0

func enter() -> void:
	super()
	parent.airdash_remaining -= 1
	print("remaining:" + str(parent.airdash_remaining))
	dash_timer = time_to_dash

	# Simple check for which direction to dash towards
	if animations.flip_h:
		direction = -1
	else:
		direction = 1

# Just to be safe, disable any other inputs
func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('switch'):
		parent.is_main = not parent.is_main
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y = 0
	dash_timer -= delta
	if dash_timer <= 0.0:
		# Fall back on the default input implementation to
		# determine where to go next
		if super.get_movement_input() != 0.0:
			return move_state
		return fall_state

	var movement = get_movement_input() * move_speed
	
	if movement == 0:
		return fall_state
	
	animations.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()

	return null

# Override movement inputs
func get_movement_input() -> float:
	return direction

func get_jump() -> bool:
	return false
