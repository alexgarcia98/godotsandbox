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
