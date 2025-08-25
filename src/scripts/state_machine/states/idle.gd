extends State

@export
var dash_state: State
@export
var fall_state: State
@export
var jump_state: State
@export
var move_state: State
@export
var pivot_state: State
@export
var single_pivot_state: State
@export
var interact_state: State
@export
var throw_state: State
@export
var thrown_state: State
@export
var frozen_state: State
@export
var switch_state: State
@export
var shoot_state: State
@export
var enter_door_state: State

var start_idle: Vector2 = Vector2(0,0)

func enter() -> void:
	if not parent.flip_toggled:
		parent.flip_toggled = true
		if parent.is_flipped:
			parent.is_flipped = false
			animations.flip_h = true
		else:
			animations.flip_h = false
	super()
	parent.velocity.x = 0
	parent.jumps_remaining = parent.max_jumps
	parent.airdash_remaining = parent.max_airdash
	parent.air_reverse_remaining = parent.max_air_reverse
	start_idle = parent.position
	print("x0: %s: setting start_idle at %s" % [parent.name, parent.position])

func process_input(event: InputEvent) -> State:
	super(event)
	if parent.visible and parent.respawn_valid:
		if (not parent.gate_down_1.is_colliding()) and (not parent.gate_down_2.is_colliding()):
			if parent.position == start_idle:
				var tilemap = parent.get_parent()
				var x = tilemap.local_to_map(parent.position)
				# get data at player feet
				var tile = tilemap.get_cell_tile_data(x)
				print("x11: %s: tile at position %s: %s" % [parent.name, x, tile])
				if tile:
					print("%s: changing color" % parent.name)
					tile.modulate = Color.RED
					# player is stuck
				else:
					print("%s: start idle: %s, position: %s" % [parent.name, start_idle, parent.position])
					var y = tilemap.map_to_local(x)
					#y.x -= 8
					#y.y += 7.9
					parent.last_valid = y 
					parent.last_facing = animations.flip_h
					print("x1: %s: setting position at %s" % [parent.name, y])
	if Input.is_action_just_pressed('move_up'):
		# check for nearby door
		if parent.door != null and parent.key_obtained:
			return enter_door_state
	if get_jump() and parent.is_on_floor():
		return jump_state
	if get_movement_input() != 0.0:
		return move_state
	if get_advancement_input() != 0.0:
		return move_state
	if Input.is_action_just_pressed('dash'):
		return dash_state
	if Input.is_action_just_pressed('pivot'):
		return pivot_state
	#if Input.is_action_just_pressed('debug_single_pivot'):
		#return single_pivot_state
	#if Input.is_action_just_pressed('switch'):
		#parent.is_main = not parent.is_main
		#parent.indicator.visible = not parent.indicator.visible
		#if parent.is_main:
			#parent.set_z_index(7)
		#else:
			#parent.set_z_index(6)
		#return null
	if Input.is_action_just_pressed('action'):
		if parent.is_main:
			return interact_state
	if Input.is_action_just_pressed("freeze"):
		if parent.is_main:
			return frozen_state
	if Input.is_action_just_pressed("throw"):
		# check for closeness
		if parent.throwable:
			if parent.is_main:
				return throw_state
			else:
				return thrown_state
	if Input.is_action_just_pressed('shoot'):
		if parent.is_main:
			if parent.ammo > 0:
				return shoot_state
	return null

func process_physics(delta: float) -> State:
	if parent.can_move:
		parent.velocity.y += gravity * delta
		parent.velocity.x = 0
		parent.velocity = gate_check(parent.velocity)
		
		if !parent.is_on_floor():
			return fall_state
	return null
