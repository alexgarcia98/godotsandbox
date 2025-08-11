extends State

@export
var thrown_length := 5

var thrown_timer := 0.0
var direction := 1.0

@export
var idle_state: State
@export
var fall_state: State
@export
var move_state: State

@export
var jump_force: float = 500

var dir = 0

func enter() -> void:
	thrown_timer = thrown_length
	parent.velocity.y = -jump_force
	var horiz = Input.get_axis('move_left', 'move_right')
	if horiz < 0:
		animations.flip_h = true
		dir = -1
	elif horiz > 0:
		dir = 1
	else:
		dir = 0
	if parent.is_on_floor():
		parent.last_valid = parent.position
	animations.play(animation_name)

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('switch'):
		parent.is_main = not parent.is_main
		parent.indicator.visible = not parent.indicator.visible
	return null

func process_physics(delta: float) -> State:
	thrown_timer -= delta
	if thrown_timer <= 0.0:
		# Fall back on the default input implementation to
		# determine where to go next
		if super.get_movement_input() != 0.0:
			return move_state
		if !parent.is_on_floor():
			return fall_state
		return idle_state
	
	parent.velocity.y += (gravity * delta)
	
	if parent.velocity.y > 0:
		return fall_state
	
	var movement = move_speed * dir
	
	if movement != 0:
		animations.flip_h = movement < 0
	parent.velocity.x = movement
	parent.velocity = gate_check(parent.velocity)
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movement != 0:
			return move_state
		return idle_state
	
	return null
