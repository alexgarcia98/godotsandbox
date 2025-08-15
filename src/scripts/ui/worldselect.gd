extends Control

@onready var world_1: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/World1/World1
@onready var world_2: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/World2/World2
@onready var world_3: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/World3/World3
@onready var world_4: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/World4/World4
@onready var world_5: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/World1/World5
@onready var world_6: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/World2/World6
@onready var world_7: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/World3/World7
@onready var world_8: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/World4/World8
@onready var world_9: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer3/World9/World9
@onready var world_10: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer3/World2/World10
@onready var world_11: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer3/World3/World11
@onready var world_12: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer3/World4/World12

@onready var title: Button = $WorldSelect/VBoxContainer/MarginContainer3/MarginContainer2/Title

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	# init button visibility
	var mainNode = get_parent()
	var worldCount = (mainNode.levels_unlocked / 12) + 1
	
	var worldList = [
		world_1, 
		world_2,
		world_3,
		world_4,
		world_5,
		world_6,
		world_7,
		world_8,
		world_9,
		world_10,
		world_11,
		world_12
	]
	
	for i in range(worldCount, worldList.size()):
		worldList[i].disabled = true
		
	for i in range(worldList.size()):
		worldList[i].text = mainNode.worldNames[i]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_title_pressed() -> void:
	title.release_focus()
	Messages.MainMenu.emit()
