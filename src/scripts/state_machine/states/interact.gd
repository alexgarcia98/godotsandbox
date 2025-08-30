extends State

@export
var idle_state: State
@export
var fall_state: State
@export
var jump_state: State
@export
var move_state: State

var sounded = false

func enter() -> void:
	if parent.is_main:
		sounded = false
		super()
		for object in parent.interactables:
			object.activate()

func process_input(event: InputEvent) -> State:
	return super(event)

func process_physics(delta: float) -> State:
	check_stuck()
	if not parent.is_main:
		parent.velocity.y += gravity * delta
		parent.velocity = gate_check(parent.velocity)
		parent.move_and_slide()
	
		if !parent.is_on_floor():
			return fall_state
			
		if super.get_movement_input() != 0.0:
			return move_state
		if super.get_advancement_input() != 0.0:
			return move_state
		return idle_state
	else:
		if animations.frame == 10 and not sounded:
			parent.sfx.stream = Messages.interact_sound
			parent.sfx.play()
			sounded = true
		if animations.frame >= 11:
			if !parent.is_on_floor():
				return fall_state
			return idle_state
	return null
