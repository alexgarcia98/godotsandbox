extends State

@export
var idle_state: State
@export
var fall_state: State

var level_ended: bool = false

func enter() -> void:
	Messages.connect("LevelEnded", on_level_ended)
	parent.position = parent.door.position
	parent.position.y += 8
	parent.velocity.x = 0
	parent.velocity.y = 0
	level_ended = false
	Messages.DoorToggled.emit(parent.name) 
	super()

func process_input(event: InputEvent) -> State:
	super(event)
	if not level_ended:
		if Input.is_action_just_pressed('move_down'):
			Messages.DoorToggled.emit(parent.name)
			animations.self_modulate.a = 1.0
			if not parent.is_on_floor():
				return fall_state
			else:
				return idle_state
	return null

func process_physics(delta: float) -> State:
	if animations.frame > 4:
		# start fading
		var opacity = 0.1 * (14 - animations.frame)
		animations.self_modulate.a = opacity
	return null
	
func on_level_ended():
	level_ended = true
