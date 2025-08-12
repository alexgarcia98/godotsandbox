class_name State
extends Node

@export
var animation_name: String
@export
var move_speed: float = 128

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var animations: AnimatedSprite2D
var move_component
var parent: CharacterBody2D

func enter() -> void:
	animations.play(animation_name)

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('switch'):
		if parent.name == "red_player":
			parent.is_main = not parent.is_main
			parent.green_player.is_main = not parent.green_player.is_main
			parent.indicator.visible = not parent.indicator.visible
			parent.green_player.indicator.visible = not parent.green_player.indicator.visible
			if parent.is_main:
				parent.set_z_index(7)
			else:
				parent.set_z_index(6)
			if parent.green_player.is_main:
				parent.green_player.set_z_index(7)
			else:
				parent.green_player.set_z_index(6)
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null

func get_movement_input() -> float:
	return move_component.get_movement_direction()

func get_jump() -> bool:
	return move_component.wants_jump()
	
func gate_check(velocity: Vector2) -> Vector2:
	var onFloor = parent.floor_down_1.is_colliding() or parent.floor_down_2.is_colliding()
	var onCeiling = parent.ceiling_up_1.is_colliding() or parent.ceiling_up_2.is_colliding()
	if parent.gate_up_1.is_colliding() and not parent.gate_up_2.is_colliding():
		if onFloor:
			velocity.x = 500
			print("moving right")
	if not parent.gate_up_1.is_colliding() and parent.gate_up_2.is_colliding():
		if onFloor:
			velocity.x = -500
			print("moving left")
	if parent.gate_up_1.is_colliding() and parent.gate_up_2.is_colliding():
		if onFloor:
			velocity.x = -500
			print("moving left")
	if parent.gate_down_1.is_colliding() and not parent.gate_down_2.is_colliding():
		if onCeiling:
			velocity.x = 500
			print("moving right")
	if not parent.gate_down_1.is_colliding() and parent.gate_down_2.is_colliding():
		if onCeiling:
			velocity.x = -500
			print("moving left")
	if parent.gate_down_1.is_colliding() and parent.gate_down_2.is_colliding():
		if onCeiling:
			velocity.x = -500
			print("moving left")
	return velocity
