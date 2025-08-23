extends State

@export
var idle_state: State
@export
var fall_state: State

@export
var move_state: State
@export
var jump_state: State

var is_frozen = false

func enter() -> void:
	if parent.is_main:
		super()
		parent.velocity.x = 0
		parent.velocity.y = 0
		parent.collision_layer = 1
		is_frozen = true
		parent.sfx.stream = Messages.freeze_sound
		parent.sfx.play()

func process_input(event: InputEvent) -> State:
	super(event)
	if not parent.is_main and not is_frozen:
		if not parent.is_on_floor():
			return fall_state
		else:
			return idle_state
	else:
		if Input.is_action_just_pressed('freeze') and parent.is_main:
			if not parent.is_on_floor():
				if parent.name == "green_player":
					parent.collision_layer = 4
				elif parent.name == "red_player":
					parent.collision_layer = 2
				is_frozen = false
				parent.sfx.stream = Messages.thaw_sound
				parent.sfx.play()
				return fall_state
			else:
				if parent.name == "green_player":
					parent.collision_layer = 4
				elif parent.name == "red_player":
					parent.collision_layer = 2
				is_frozen = false
				parent.sfx.stream = Messages.thaw_sound
				parent.sfx.play()
				return idle_state
		#elif Input.is_action_just_pressed('switch'):
			#parent.is_main = not parent.is_main
			#parent.indicator.visible = not parent.indicator.visible
			#if parent.is_main:
				#parent.set_z_index(7)
			#else:
				#parent.set_z_index(6)
		return null

func process_physics(delta: float) -> State:
	if not parent.is_main && not is_frozen:
		parent.velocity.y += gravity * delta
		parent.velocity = gate_check(parent.velocity)
		parent.move_and_slide()
		
		if parent.velocity.y < 0:
			if parent.jumps_remaining > 0:
				parent.jumps_remaining -= 1
				return jump_state
	
		if !parent.is_on_floor():
			return fall_state
			
		if super.get_movement_input() != 0.0:
			return move_state
		if super.get_advancement_input() != 0.0:
			return move_state
		return idle_state
	return null
