extends AnimatableBody2D

var shot_count = 0
@onready var ice_block_popo: AnimatableBody2D = $"../IceBlockPopo"
@onready var ice_block_nana: AnimatableBody2D = $"../IceBlockNana"
@onready var popo: AnimatableBody2D = $"../Popo"
@onready var nana: AnimatableBody2D = $"../Nana"
@onready var popo_gate: AnimatableBody2D = $"../objects/popo_gate"
@onready var nana_gate: AnimatableBody2D = $"../objects/nana_gate"
@onready var blizzard: AnimatableBody2D = $"../Blizzard"
@onready var blizzard_2: AnimatableBody2D = $"../Blizzard2"
@onready var blizzard_3: AnimatableBody2D = $"../Blizzard3"
@onready var blizzard_4: AnimatableBody2D = $"../Blizzard4"
@onready var blizzard_5: AnimatableBody2D = $"../Blizzard5"
@onready var blizzard_6: AnimatableBody2D = $"../Blizzard6"
@onready var blizzard_7: AnimatableBody2D = $"../Blizzard7"
@onready var blizzard_8: AnimatableBody2D = $"../Blizzard8"
@onready var blizzard_9: AnimatableBody2D = $"../Blizzard9"
@onready var blizzard_10: AnimatableBody2D = $"../Blizzard10"

func decrease():
	shot_count += 1
	if shot_count <= 10:
		var hpbar = get_node("HP%s" % shot_count)
		hpbar.visible = false
	if shot_count == 10:
		stop_system()

func stop_system():
	if name == "PopoHP":
		ice_block_nana.animation_player.play("stop")
		blizzard_6.animation_player.play("stop")
		blizzard_7.animation_player.play("stop")
		blizzard_8.animation_player.play("stop")
		blizzard_9.animation_player.play("stop")
		blizzard_10.animation_player.play("stop")
		popo.visible = false
		popo.position.y += 1000
		nana_gate.change_state()
	elif name == "NanaHP":
		ice_block_popo.animation_player.play("stop")
		blizzard.animation_player.play("stop")
		blizzard_2.animation_player.play("stop")
		blizzard_3.animation_player.play("stop")
		blizzard_4.animation_player.play("stop")
		blizzard_5.animation_player.play("stop")
		nana.visible = false
		nana.position.y += 1000
		popo_gate.change_state()
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
