class_name Player
extends CharacterBody2D

@onready
var movement_animations: AnimatedSprite2D = $movement_animations

@onready var indicator: Polygon2D = $indicator

@onready
var object_collision: Area2D = $object_collision
@onready var collision_shape_2d: CollisionShape2D = $object_collision/CollisionShape2D

@onready var wall_left: RayCast2D = $wall_left
@onready var air_left: RayCast2D = $air_left
@onready var wall_right: RayCast2D = $wall_right
@onready var air_right: RayCast2D = $air_right
@onready var air_left_2: RayCast2D = $air_left2
@onready var air_right_2: RayCast2D = $air_right2
@onready var air_left_3: RayCast2D = $air_left3
@onready var air_right_3: RayCast2D = $air_right3
@onready var floor_down_3: RayCast2D = $floor_down_3
@onready var floor_down_4: RayCast2D = $floor_down_4
@onready var gate_up_1: RayCast2D = $gate_up_1
@onready var gate_up_2: RayCast2D = $gate_up_2
@onready var gate_down_1: RayCast2D = $gate_down_1
@onready var gate_down_2: RayCast2D = $gate_down_2
@onready var ceiling_up_1: RayCast2D = $ceiling_up_1
@onready var ceiling_up_2: RayCast2D = $ceiling_up_2
@onready var floor_down_1: RayCast2D = $floor_down_1
@onready var floor_down_2: RayCast2D = $floor_down_2
@onready var floor_down_5: RayCast2D = $floor_down_5
@onready var floor_down_6: RayCast2D = $floor_down_6

@onready
var movement_state_machine: Node = $movement_state_machine

@onready
var player_move_component = $player_move_component

@onready var sfx: AudioStreamPlayer2D = $sfx


var level_parent: Node
var green_player: Player

@export
var is_main: bool = true
@export
var is_flipped: bool = false
@export
var max_jumps: int = 2

@export
var max_airdash: int = 1

@export
var max_air_reverse: int = 1

@export
var ammo: int = 10

@export
var throwable = false

var jumps_remaining = max_jumps
var airdash_remaining = max_airdash
var air_reverse_remaining = max_air_reverse
var interactables = []
var door = null
var last_valid: Vector2 = Vector2(0,0)
var last_facing = true
var respawn_valid = true
var key_obtained = false
var door_opened = false
var flip_toggled = false

var danger_list = []
var tile_list = []

var can_move = false

func _ready() -> void:
	movement_state_machine.init(self, movement_animations, player_move_component)
	#gun_state_machine.init(self, gun_animations, player_move_component)
	last_valid = position
	last_facing = is_flipped
	Messages.connect("KeyObtained", on_key_obtained)
	Messages.connect("BeginLevel", on_begin_level)
	Messages.connect("LevelStarted", on_level_started)
	Messages.connect("LevelEnded", on_level_ended)
	if name == "red_player":
		level_parent = get_parent()
		green_player = level_parent.get_node("green_player")
	if is_main:
		set_z_index(7)
		indicator.visible = true
	else:
		set_z_index(6)
		indicator.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if visible and can_move:
		movement_state_machine.process_input(event)
		#gun_state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	movement_state_machine.process_physics(delta)
	#gun_state_machine.process_physics(delta)

func _process(delta: float) -> void:
	movement_state_machine.process_frame(delta)
	#gun_state_machine.process_frame(delta)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("%s entered" % body)
	if body.get_collision_layer_value(2) or body.get_collision_layer_value(3):
		if is_main:
			print("%s can throw" % name)
		else:
			print("%s can be thrown" % name)
		throwable = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	print("%s exited" % body)
	if body.get_collision_layer_value(2) or body.get_collision_layer_value(3):
		if is_main:
			print("%s cannot throw" % name)
		else:
			print("%s cannot be thrown" % name)
		throwable = false

func _on_object_collision_area_entered(area: Area2D) -> void:
	# handle any auto pickups
	if area.get_collision_layer_value(5) or area.get_collision_layer_value(7):
		area.activate()
		return
	# handle doors
	if area.get_collision_layer_value(11) or area.get_collision_layer_value(12):
		door = area
		if key_obtained:
			if not door_opened:
				door_opened = true
				area.change_state()
	# check if present
	if not interactables.has(area):
		interactables.append(area)
	#if area.get_collision_layer_value(9) or area.get_collision_layer_value(10):
		#respawn_valid = false
		#print("respawn invalid")
		#if not danger_list.has(area):
			#danger_list.append(area)
		#print("danger list on entrance: " + str(danger_list))
	print("entered: " + str(area))

func _on_object_collision_area_exited(area: Area2D) -> void:
	if interactables.has(area):
		interactables.erase(area)
	#if area.get_collision_layer_value(9) or area.get_collision_layer_value(10):
		#respawn_valid = true
		#print("respawn valid")
		#if danger_list.has(area):
			#danger_list.erase(area)
		#print("danger list on exit: " + str(danger_list))
	print("exited: " + str(area))
	
func on_key_obtained(key_name):
	if key_name == "green_key" and name == "green_player":
		key_obtained = true
	elif key_name == "red_key" and name == "red_player":
		key_obtained = true

func on_begin_level(_index):
	can_move = true

func on_level_started(_index):
	can_move = false
	
func on_level_ended():
	can_move = false
