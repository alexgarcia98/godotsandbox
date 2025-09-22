extends State

@export
var idle_state: State

var replay_actions_red = [
	Vector2(0, 0),
	Vector2(8, -8),
	Vector2(16, -16),
	Vector2(24, -24),
	Vector2(32, -32),
	Vector2(40, -40),
	Vector2(48, -48),
	Vector2(56, -56),
	Vector2(64, -64),
	Vector2(72, -72),
]

var replay_actions_green = [
	Vector2(0, 0),
	Vector2(-8, -8),
	Vector2(-16, -16),
	Vector2(-24, -24),
	Vector2(-32, -32),
	Vector2(-40, -40),
	Vector2(-48, -48),
	Vector2(-56, -56),
	Vector2(-64, -64),
	Vector2(-72, -72),
]

var start_time
var next_action_time
var action_count = 0

func enter() -> void:
	super()
	start_time = Time.get_ticks_msec()
	next_action_time = start_time
	action_count = 0
	parent.velocity.x = 0
	parent.velocity.y = 0

func process_input(event: InputEvent) -> State:
	return super(event)

func process_physics(delta: float) -> State:
	var current_time = Time.get_ticks_msec()
	if parent.name == "red_player":
		if action_count >= replay_actions_red.size():
			animations.modulate = Color.WHITE
			animations.modulate.a = 1
			return idle_state
		if current_time > next_action_time:
			parent.global_position = replay_actions_red[action_count]
			animations.modulate = Color.RED
			animations.modulate.a = 0.5
			action_count += 1
			next_action_time += 100
	if parent.name == "green_player":
		if action_count >= replay_actions_green.size():
			animations.modulate = Color.WHITE
			animations.modulate.a = 1
			return idle_state
		if current_time > next_action_time:
			parent.global_position = replay_actions_green[action_count]
			animations.modulate = Color.WEB_GREEN
			animations.modulate.a = 0.5
			action_count += 1
			next_action_time += 100
	return null
			
