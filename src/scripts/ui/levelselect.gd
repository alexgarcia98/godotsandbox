extends Control

@onready var title: Button = $WorldSelect/VBoxContainer/MarginContainer3/MarginContainer2/Title
@onready var back: Button = $WorldSelect/VBoxContainer/MarginContainer3/MarginContainer2/Back
@onready var select_level: Label = $WorldSelect/VBoxContainer/MarginContainer3/MarginContainer2/SelectLevel

@onready var level_1: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Level1/Level1
@onready var level_2: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Level2/Level2
@onready var level_3: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Level3/Level3
@onready var level_4: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Level4/Level4
@onready var level_5: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/Level5/Level5
@onready var level_6: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/Level6/Level6
@onready var level_7: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/Level7/Level7
@onready var level_8: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/Level8/Level8
@onready var level_9: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer3/Level9/Level9
@onready var level_10: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer3/Level10/Level10
@onready var level_11: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer3/Level11/Level11
@onready var level_12: Button = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer3/Level12/Level12

@export var world_level: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	# init button visibility
	var mainNode = get_parent()
	var levelCount = min(mainNode.levels_unlocked, Messages.max_levels + 1)
	
	var levelList = [
		level_1, 
		level_2,
		level_3,
		level_4,
		level_5,
		level_6,
		level_7,
		level_8,
		level_9,
		level_10,
		level_11,
		level_12
	]
	
	for i in range(levelList.size()):
		levelList[i].level = (world_level * 12) + i
	
	var max_level = level_12.level + 1
	print("max_level: " + str(max_level))
	print("levelCount: " + str(levelCount))
	if levelCount < max_level:
		var start = levelCount % 12
		for i in range(start, levelList.size()):
			levelList[i].disabled = true
			
	for i in range(max_level - 13, max_level):
		var level = levelList[i % 12]
		var worldName = Messages.worldNames[i / 12]
		level.text = Messages.worldLevels[worldName][i % 12]
	
	var worldIndex = level_1.level / 12
	select_level.text = Messages.worldNames[worldIndex]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_title_pressed() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	title.release_focus()
	Messages.MainMenu.emit()


func _on_back_pressed() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	back.release_focus()
	Messages.WorldSelect.emit()
