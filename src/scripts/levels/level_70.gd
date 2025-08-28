extends TileMapLayer

@onready var cover_1: AnimatableBody2D = $cover1
@onready var cover_2: AnimatableBody2D = $cover2
@onready var cover_3: AnimatableBody2D = $cover3
@onready var cover_4: AnimatableBody2D = $cover4
@onready var cover_5: AnimatableBody2D = $cover5
@onready var cover_6: AnimatableBody2D = $cover6
@onready var cover_7: AnimatableBody2D = $cover7
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2
@onready var ray_cast_2d_3: RayCast2D = $RayCast2D3
@onready var ray_cast_2d_4: RayCast2D = $RayCast2D4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cover_1.visible = false
	cover_2.visible = true
	cover_3.visible = true
	cover_4.visible = true
	cover_5.visible = true
	cover_6.visible = true
	cover_7.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ray_cast_2d.is_colliding():
		cover_2.visible = false
	if ray_cast_2d_2.is_colliding():
		cover_5.visible = false
	if ray_cast_2d_3.is_colliding():
		cover_3.visible = false
	if ray_cast_2d_4.is_colliding():
		cover_4.visible = false
