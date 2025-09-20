extends TileMapLayer

signal LevelDone(emitter)
@onready var purple_gate: AnimatableBody2D = $objects/purple_gate
@export var target_count = 10
@onready var timer: Timer = $Timer
@onready var platform_2: AnimatableBody2D = $Platform_2
@onready var platform_3: AnimatableBody2D = $Platform_3
@onready var platform_4: AnimatableBody2D = $Platform_4
@onready var platform_1: AnimatableBody2D = $Platform_1
@onready var platform_0: AnimatableBody2D = $Platform_0
@onready var animation_player_2: AnimationPlayer = $Platform_2/AnimationPlayer
@onready var animation_player_3: AnimationPlayer = $Platform_3/AnimationPlayer
@onready var animation_player_4: AnimationPlayer = $Platform_4/AnimationPlayer
@onready var animation_player_1: AnimationPlayer = $Platform_1/AnimationPlayer
@onready var animation_player_0: AnimationPlayer = $Platform_0/AnimationPlayer

var preloaded
var count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messages.connect("TargetHit", on_target_hit)
	Messages.connect("BeginLevel", on_begin_level)

func on_begin_level(_current_index):
	print("signal received in %s" % name)
	if animation_player_0 != null:
		animation_player_0.play("start")
	timer.start()
		
func on_target_hit():
	target_count -= 1
	if target_count == 0:
		purple_gate.change_state()

func _on_timer_timeout() -> void:
	count += 1
	var index = count % 5
	print("playing %s" % index)
	if index == 0:
		animation_player_0.queue("start")
	elif index == 1:
		animation_player_1.queue("start")
	elif index == 2:
		animation_player_2.queue("start")
	elif index == 3:
		animation_player_3.queue("start")
	elif index == 4:
		animation_player_4.queue("start")
