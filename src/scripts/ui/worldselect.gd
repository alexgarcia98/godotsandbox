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

@onready var rank_1: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/World1/MarginContainer/Rank1
@onready var rank_2: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/World2/MarginContainer/Rank2
@onready var rank_3: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/World3/MarginContainer/Rank3
@onready var rank_4: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/World4/MarginContainer/Rank4
@onready var rank_5: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/World1/MarginContainer/Rank5
@onready var rank_6: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/World2/MarginContainer/Rank6
@onready var rank_7: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/World3/MarginContainer/Rank7
@onready var rank_8: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/World4/MarginContainer/Rank8
@onready var rank_9: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer3/World9/MarginContainer/Rank9
@onready var rank_10: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer3/World2/MarginContainer/Rank10
@onready var rank_11: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer3/World3/MarginContainer/Rank11
@onready var rank_12: Label = $WorldSelect/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer3/World4/MarginContainer/Rank12

@onready var title: Button = $WorldSelect/VBoxContainer/MarginContainer3/MarginContainer2/Title

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	# init button visibility
	var mainNode = get_parent()
	
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
		rank_12
	]
		
	for i in range(worldList.size()):
		if i == 3:
			worldList[i].text = "Bonus 1:\n" + Messages.worldNames[i]
		elif i == 7:
			worldList[i].text = "Bonus 2:\n" + Messages.worldNames[i]
		else:
			worldList[i].text = Messages.worldNames[i]
		if Messages.unlocked_levels[Messages.worldNames[i]] == 0:
			worldList[i].disabled = true
			
		
	
	for i in range(worldList.size()):
		var world_rank = Messages.get_world_rank(i)
		var rank = rankList[i]
		if world_rank == "None":
			world_rank = ""
		rank.set("theme_override_colors/font_color", Color(Messages.get_rank_color(world_rank)))
		rank.text = world_rank
	
	world_1.grab_focus.call_deferred()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_title_pressed() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	title.release_focus()
	Messages.MainMenu.emit()
