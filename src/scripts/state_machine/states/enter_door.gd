extends State

@export
var idle_state: State
@export
var fall_state: State

func enter() -> void:
	parent.position = parent.door.position
	parent.position.y += 8
	parent.velocity.x = 0
	parent.velocity.y = 0
	Messages.DoorToggled.emit(parent.name) 
	print(parent.name + ": 1")
	super()
	print(parent.name + ": 2")

func process_input(event: InputEvent) -> State:
	print(parent.name + ": 3")
	super(event)
	print(parent.name + ": 4")
	if Input.is_action_just_pressed('move_down'):
		Messages.DoorToggled.emit(parent.name)
		animations.self_modulate.a = 1.0
		if not parent.is_on_floor():
			print(parent.name + ": 5")
			return fall_state
			print(parent.name + ": 6")
		else:
			print(parent.name + ": 7")
			return idle_state
			print(parent.name + ": 8")
	print(parent.name + ": 9")
	return null

func process_physics(delta: float) -> State:
	if animations.frame > 4:
		# start fading
		var opacity = 0.1 * (14 - animations.frame)
		animations.self_modulate.a = opacity
	return null
