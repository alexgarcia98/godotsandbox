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
	# load in projectile
	var pscene
	if parent.name == "red_player":
		pscene = load("src/objects/red_shot.tscn")
	elif parent.name == "green_player":
		pscene = load("src/objects/green_shot.tscn")
	var objects: Node = get_parent().get_parent().get_parent()
	var x = objects.name
	var objects1: Node = objects.get_node("objects")
	var projectile = pscene.instantiate()
	projectile.position = parent.position
	if animations.flip_h:
		projectile.scale.x = -1
		projectile.position.x -= 16
	else:
		projectile.scale.x = 1
		projectile.position.x += 16
	objects1.add_child(projectile)
	parent.ammo -= 1
	Messages.ShotFired.emit(parent.name)

#func process_input(event: InputEvent) -> State:
	#if Input.is_action_just_pressed('switch'):
		#parent.is_main = not parent.is_main
		#parent.indicator.visible = not parent.indicator.visible
		#if parent.is_main:
			#parent.set_z_index(7)
		#else:
			#parent.set_z_index(6)
	#return null

func process_physics(delta: float) -> State:
	parent.velocity.y += (gravity * delta)
	var movement = get_movement_input() * move_speed
	parent.velocity.x = movement
	parent.velocity = gate_check(parent.velocity)
	parent.move_and_slide()
	if not parent.is_main:
		if !parent.is_on_floor():
			return fall_state
			
		if super.get_movement_input() != 0.0:
			return move_state
		return idle_state
	else:
		if animations.frame >= 5:
			if !parent.is_on_floor():
				return fall_state
			if super.get_movement_input() != 0.0:
				return move_state
			return idle_state
	return null
