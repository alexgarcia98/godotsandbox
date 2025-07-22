extends State

@export
var idle_state: State
@export
var fall_state: State

var is_frozen = false

func enter() -> void:
	if parent.is_main:
		super()
		parent.velocity.x = 0
		parent.velocity.y = 0
		parent.collision_layer = 1
		is_frozen = true

func process_input(event: InputEvent) -> State:
	if not parent.is_main and not is_frozen:
		if not parent.is_on_floor():
			return fall_state
		else:
			return idle_state
	else:
		if Input.is_action_just_pressed('action') and parent.is_main:
			if not parent.is_on_floor():
				parent.collision_layer = 4
				is_frozen = false
				return fall_state
			else:
				parent.collision_layer = 4
				is_frozen = false
				return idle_state
		elif Input.is_action_just_pressed('switch'):
			parent.is_main = not parent.is_main
		return null

func process_physics(delta: float) -> State:
	if not parent.is_main && not is_frozen:
		parent.velocity.y += gravity * delta
		parent.move_and_slide()

	return null
