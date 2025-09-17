extends TileMapLayer

signal LevelDone(emitter)
@export var target_count = 2
@onready var red_gate_5: AnimatableBody2D = $objects/red_gate5
@onready var red_gate_6: AnimatableBody2D = $objects/red_gate6
@onready var red_gate_7: AnimatableBody2D = $objects/red_gate7
@onready var red_gate_8: AnimatableBody2D = $objects/red_gate8
@onready var red_button: Area2D = $objects/red_button
@onready var red_button_2: Area2D = $objects/red_button2
@onready var part_2_bg: TileMapLayer = $Part2_BG
@onready var part_1: TileMapLayer = $Part1
@onready var part_2: TileMapLayer = $Part2
@onready var kill_both_22: Area2D = $objects/kill_both22
@onready var kill_both_23: Area2D = $objects/kill_both23
@onready var kill_both_24: Area2D = $objects/kill_both24

@onready var kill_both_25: Area2D = $objects/kill_both25
@onready var kill_both_26: Area2D = $objects/kill_both26
@onready var kill_both_27: Area2D = $objects/kill_both27
@onready var kill_both_28: Area2D = $objects/kill_both28

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messages.connect("TargetHit", on_target_hit)
	red_gate_5.position.y += 1000
	red_gate_6.position.y += 1000
	red_gate_7.position.y += 1000
	red_gate_8.position.y += 1000
	red_button.position.y += 1000
	red_button_2.position.y += 1000
	part_1.visible = true
	part_2.visible = false
	part_2_bg.visible = false
	part_2.position.y += 5000
	kill_both_25.position.y += 3000
	kill_both_26.position.y += 3000
	kill_both_27.position.y += 3000
	kill_both_28.position.y += 3000

func on_target_hit():
	target_count -= 1
	if target_count == 0:
		red_gate_5.position.y -= 1000
		red_gate_6.position.y -= 1000
		red_gate_7.position.y -= 1000
		red_gate_8.position.y -= 1000
		red_button.position.y -= 1000
		red_button_2.position.y -= 1000
		kill_both_22.position.y += 5000
		kill_both_23.position.y += 5000
		kill_both_24.position.y += 5000
		kill_both_25.position.y -= 3000
		kill_both_26.position.y -= 3000
		kill_both_27.position.y -= 3000
		kill_both_28.position.y -= 3000
		
		part_2.position.y -= 5000
		part_1.visible = false
		part_2.visible = true
		part_2_bg.visible = true
