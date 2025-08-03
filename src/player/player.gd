class_name Player
extends CharacterBody2D

@onready
var movement_animations: AnimatedSprite2D = $movement_animations
@onready
var gun_animations: AnimatedSprite2D = $gun_animations

@onready var indicator: Polygon2D = $indicator

@onready
var object_collision: Area2D = $object_collision

@onready
var movement_state_machine: Node = $movement_state_machine
@onready
var gun_state_machine: Node = $gun_state_machine
@onready
var player_move_component = $player_move_component
@export
var is_main: bool = true

@export
var max_jumps: int = 2

@export
var max_airdash: int = 1

@export
var max_air_reverse: int = 1

@export
var throwable = false

var jumps_remaining = max_jumps
var airdash_remaining = max_airdash
var air_reverse_remaining = max_air_reverse
var interactables = []
var last_valid: Vector2 = Vector2(0,0)
var key_obtained = false

func _ready() -> void:
	movement_state_machine.init(self, movement_animations, player_move_component)
	gun_state_machine.init(self, gun_animations, player_move_component)
	last_valid = position
	Messages.connect("KeyObtained", on_key_obtained)
	if is_main:
		set_z_index(7)
		indicator.visible = true
	else:
		set_z_index(6)
		indicator.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if visible:
		movement_state_machine.process_input(event)
		gun_state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	movement_state_machine.process_physics(delta)
	gun_state_machine.process_physics(delta)

func _process(delta: float) -> void:
	movement_state_machine.process_frame(delta)
	gun_state_machine.process_frame(delta)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("can throw")
	throwable = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	print("cannot throw")
	throwable = false

func _on_object_collision_area_entered(area: Area2D) -> void:
	# handle any auto pickups
	if area.get_collision_layer_value(5) or area.get_collision_layer_value(7):
		area.activate()
		return
	# handle doors
	if area.get_collision_layer_value(11) or area.get_collision_layer_value(12):
		if key_obtained:
			key_obtained = false
			area.change_state()
	# check if present
	if not interactables.has(area):
		interactables.append(area)
	print(interactables)

func _on_object_collision_area_exited(area: Area2D) -> void:
	if interactables.has(area):
		interactables.erase(area)
	print(interactables)
	
func on_key_obtained(key_name):
	if key_name == "green_key" and name == "green_player":
		key_obtained = true
	elif key_name == "red_key" and name == "red_player":
		key_obtained = true
