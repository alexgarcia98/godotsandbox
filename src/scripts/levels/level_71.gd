extends TileMapLayer

@onready var label_5: Label = $Label5
@onready var green_button: Area2D = $objects/green_button
@onready var green_button_2: Area2D = $objects/green_button2
@onready var red_button: Area2D = $objects/red_button
@onready var red_button_2: Area2D = $objects/red_button2
@onready var timer: Timer = $Timer
@onready var timer_2: Timer = $Timer2
@onready var green_gate: AnimatableBody2D = $objects/green_gate
@onready var gengar: AnimatableBody2D = $gengar
@onready var label_7: Label = $Label7
@onready var label_8: Label = $Label8
@onready var label_13: Label = $Label13
@onready var label_12: Label = $Label12

signal AttackEnded(emitter)
signal LevelDone(emitter)

var active = false
var effective = true
@onready var hp_bar: AnimatableBody2D = $hp_bar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_5.text = ""
	active = false
	effective = false
	connect("AttackEnded", green_button.turn_off)
	connect("AttackEnded", red_button.turn_off)
	connect("AttackEnded", green_button_2.turn_off)
	connect("AttackEnded", red_button_2.turn_off)
	connect("LevelDone", green_gate.change_state)

func _on_green_button_button_pressed() -> void:
	if not active:
		active = true
		label_5.text = "NIDOKING\nused EARTHQUAKE!"
		effective = true
		hp_bar.deplete()
		timer.start()
		
func _on_timer_timeout() -> void:
	if effective:
		label_5.text = "It's super\neffective!"
	else:
		label_5.text = "It doesn't affect\nEnemy GENGAR!"
	timer_2.start()

func _on_green_button_2_button_pressed() -> void:
	if not active:
		active = true
		label_5.text = "NIDOKING\nused TOXIC!"
		timer.start()

func _on_timer_2_timeout() -> void:
	if effective:
		label_5.text = "Enemy GENGAR\nfainted!"
		label_7.visible = false
		label_8.visible = false
		label_12.visible = false
		label_13.visible = false
		hp_bar.visible = false
		gengar.visible = false
		emit_signal("LevelDone")
	else:
		label_5.text = ""
		active = false
	emit_signal("AttackEnded")

func _on_red_button_button_pressed() -> void:
	if not active:
		active = true
		label_5.text = "NIDOKING\nused DOUBLE KICK!"
		timer.start()

func _on_red_button_2_button_pressed() -> void:
	if not active:
		active = true
		label_5.text = "NIDOKING\nused BODY SLAM!"
		timer.start()
