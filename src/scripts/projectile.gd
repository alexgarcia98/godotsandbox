extends Polygon2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x = (position.x + ((delta * 500) * scale.x))

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("projectile entered object: " + area.name)
	area.activate()
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("projectile collided with: " + body.name)
	queue_free()
