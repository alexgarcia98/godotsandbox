extends Node

@onready var green_key: RichTextLabel = $green_key
@onready var red_key: RichTextLabel = $red_key

func _ready():
	Messages.connect("KeyObtained", on_key_obtained)
	
func on_key_obtained(name):
	if name == "green_key":
		green_key.text = "Green Key Obtained"
	elif name == "red_key":
		red_key.text = "Red Key Obtained"
