extends State

@export
var dash_state: State
@export
var fall_state: State
@export
var idle_state: State
@export
var jump_state: State
@export
var airdash_state: State
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

func enter() -> void:
	super()
	parent.jumps_remaining = parent.max_jumps
	parent.airdash_remaining = parent.max_airdash
	parent.air_reverse_remaining = parent.max_air_reverse
	parent.last_position = parent.position
	parent.stuck_count = 0

func process_input(event: InputEvent) -> State:
	super(event)
	if Input.is_action_just_pressed('jump'):
		if parent.jumps_remaining > 0:
			# set current position
			if parent.visible and parent.respawn_valid:
				if (not parent.gate_down_1.is_colliding()) and (not parent.gate_down_2.is_colliding()):
					var tilemap = parent.get_parent()
					var x = tilemap.local_to_map(parent.position)
					# get data at player feet
					var tile = tilemap.get_cell_tile_data(x)
					print("x12: %s: tile at position %s: %s" % [parent.name, x, tile])
					if tile:
						print("%s: changing color" % parent.name)
						tile.modulate = Color.RED
						# player is stuck
					else:
						var y = tilemap.map_to_local(x)
						#y.x -= 8
						#y.y += 7.9
						parent.last_valid = y 
						parent.last_facing = animations.flip_h
						print("x2: %s: setting position at %s" % [parent.name, y])
			return jump_state
	if Input.is_action_just_pressed('dash'):
		if parent.is_on_floor():
			if parent.visible and parent.respawn_valid:
				if (not parent.gate_down_1.is_colliding()) and (not parent.gate_down_2.is_colliding()):
					var tilemap = parent.get_parent()
					var x = tilemap.local_to_map(parent.position)
					# get data at player feet
					var tile = tilemap.get_cell_tile_data(x)
					print("x13: %s: tile at position %s: %s" % [parent.name, x, tile])
					if tile:
						print("%s: changing color" % parent.name)
						tile.modulate = Color.RED
						# player is stuck
					else:
						var y = tilemap.map_to_local(x)
						#y.x -= 8
						#y.y += 7.9
						parent.last_valid = y 
						parent.last_facing = animations.flip_h
						print("x3: %s: setting position at %s" % [parent.name, y])
			return dash_state
		else:
			if parent.airdash_remaining > 0:
				return airdash_state
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
	if Input.is_action_just_pressed('move_up'):
		# check for nearby door
		if parent.door != null and parent.key_obtained:
			return enter_door_state
	return null

func process_physics(delta: float) -> State:
	print("x4: in move physics: %s: wall: %s" % [parent.name, parent.is_on_wall()])
	parent.velocity.y += (gravity * delta)

	var movement = get_movement_input() * move_speed
	var advancement = get_advancement_input() * move_speed
	
	if movement == 0:
		if advancement == 0:
			return idle_state
		else:
			parent.velocity.x = advancement
			if animations.flip_h:
				parent.velocity.x *= -1
			parent.velocity = gate_check(parent.velocity)
	else:
		animations.flip_h = movement < 0
		parent.velocity.x = movement
		parent.velocity = gate_check(parent.velocity)
		
		if !parent.is_on_floor():
			return fall_state
	return null
