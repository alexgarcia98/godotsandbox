extends State

@export
var idle_state: State
@export
var fall_state: State
@export
var jump_state: State
@export
var move_state: State

func enter() -> void:
	if parent.is_main:
		super()
		for object in parent.interactables:
			object.activate()

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('switch'):
		parent.is_main = not parent.is_main
		parent.indicator.visible = not parent.indicator.visible
	return null

func process_physics(delta: float) -> State:
	if not parent.is_main:
		parent.velocity.y += gravity * delta
		parent.move_and_slide()
		
		if parent.velocity.y < 0:
			return jump_state
	
		if !parent.is_on_floor():
			return fall_state
			
		if super.get_movement_input() != 0.0:
			return move_state
		return idle_state
	else:
		if animations.frame >= 11:
			if !parent.is_on_floor():
				return fall_state
			return idle_state
	return null
