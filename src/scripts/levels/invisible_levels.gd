extends TileMapLayer

@onready var tile_map_layer_2: TileMapLayer = $TileMapLayer2
@onready var timer: Timer = $Timer
@onready var timer_2: Timer = $Timer2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messages.connect("BeginLevel", on_begin_level)

func on_begin_level(_current_index):
	timer.start()

func _on_timer_timeout() -> void:
	var tween = tile_map_layer_2.create_tween()
	tween.tween_property(tile_map_layer_2, "modulate:a", 0.0, 0.5)
	timer_2.start()
	
func _on_timer_2_timeout() -> void:
	var tween = tile_map_layer_2.create_tween()
	tween.tween_property(tile_map_layer_2, "modulate:a", 1.0, 0.5)
	timer.start()
