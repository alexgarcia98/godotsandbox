extends Node

@export
var starting_state: State

var current_state: State
var player_character
var move_comp

@onready var idle: Node = $idle
@onready var move: Node = $move
@onready var replay: Node = $replay

# Initialize the state machine by giving each child state a reference to the
# parent object it belongs to and enter the default starting_state.
func init(parent: CharacterBody2D, animations: AnimatedSprite2D, move_component) -> void:
	Messages.connect("PlayerRevived", on_player_revived)
	Messages.connect("Replay", on_replay)
	player_character = parent
	move_comp = move_component
	for child in get_children():
		child.parent = parent
		child.animations = animations
		child.move_component = move_component
	
	# Initialize to the default state
	change_state(starting_state)

# Change to the new state by first calling any exit logic on the current state.
func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
		
	current_state = new_state
	print(current_state.parent.name + ": " + current_state.name)
	current_state.enter()
	
# Pass through functions for the Player to call,
# handling state changes as needed.
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)

func on_player_revived(player_name):
	if player_name == player_character.name:
		if move_comp.get_movement_direction() != 0.0:
			change_state(move)
		elif move_comp.get_advancement_direction() != 0.0:
			change_state(move)
		else:
			change_state(idle)

func on_replay():
	pass
	#change_state(replay)
