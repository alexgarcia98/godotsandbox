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

@onready var rank_1: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Level1/MarginContainer/Rank1
@onready var rank_2: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Level2/MarginContainer/Rank2
@onready var rank_3: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Level3/MarginContainer/Rank3
@onready var rank_4: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Level4/MarginContainer/Rank4
@onready var rank_5: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/Level5/MarginContainer/Rank5
@onready var rank_6: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/Level6/MarginContainer/Rank6
@onready var rank_7: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/Level7/MarginContainer/Rank7
@onready var rank_8: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/Level8/MarginContainer/Rank8
@onready var rank_9: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer3/Level9/MarginContainer/Rank9
@onready var rank_10: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer3/Level10/MarginContainer/Rank10
@onready var rank_11: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer3/Level11/MarginContainer/Rank11
@onready var rank_12: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer3/Level12/MarginContainer/Rank12

@export var world_level: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	# init button visibility
	var mainNode = get_parent()
	var levelCount = min(Messages.levels_unlocked, Messages.max_levels + 1)
	
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
	
	var rankList = [
		rank_1,
		rank_2,
		rank_3,
		rank_4,
		rank_5,
		rank_6,
		rank_7,
		rank_8,
		rank_9,
		rank_10,
		rank_11,
		rank_12,
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
		var rank = rankList[i % 12]
		var worldName = Messages.worldNames[i / 12]
		var level_rank = Messages.get_stored_rank(i)
		rank.set("theme_override_colors/font_color", Color(Messages.get_rank_color(level_rank)))
		if level_rank == "None":
			level_rank = ""
		rank.text = level_rank
		level.text = Messages.worldLevels[worldName][i % 12]
	
	var worldIndex = level_1.level / 12
	select_level.text = Messages.worldNames[worldIndex]
	
	level_1.grab_focus.call_deferred()

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
