extends State

@export
var idle_state: State

@export
var fall_state: State

@export
var airdash_state: State

@export
var jump_state: State

var flipped = false

func enter() -> void:
	super()
	flipped = false
	parent.velocity.x = 0
	parent.air_reverse_remaining -= 1
	parent.sfx.stream = Messages.pivot_sound
	parent.sfx.play()

func process_input(event: InputEvent) -> State:
	super(event)
	if Input.is_action_just_pressed('dash'):
		if animations.frame > 2 and flipped:
			if parent.airdash_remaining > 0:
				return airdash_state
		elif animations.frame >= 5:
			if parent.airdash_remaining > 0:
				return airdash_state
	if Input.is_action_just_pressed('jump'):
		if parent.jumps_remaining > 0:
			if animations.frame > 2 and flipped:
				parent.jumps_remaining -= 1
				return jump_state
			elif animations.frame >= 5:
				parent.jumps_remaining -= 1
				return jump_state
	return null

func process_physics(delta: float) -> State:
	if animations.frame > 2 and not flipped:
		animations.flip_h = not animations.flip_h
		flipped = true
	parent.velocity.y = 0
	parent.velocity = gate_check(parent.velocity)
	parent.move_and_slide()
	
	if animations.frame >= 5:
		flipped = false
		if !parent.is_on_floor():
			return fall_state
		return idle_state
	return null
