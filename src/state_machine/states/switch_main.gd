extends State

@export
var idle_state: State
@export
var fall_state: State

func enter() -> void:
	parent.is_main = not parent.is_main

	var switch_animation = "sub_switch"
	if parent.is_main:
		switch_animation = "main_switch"
		
	animations.play(switch_animation)

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
		
	if animations.frame >= 5:
		return idle_state
	return null
