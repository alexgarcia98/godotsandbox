extends MarginContainer

class_name ExpandRecordContainer
@export
var world_number: int
@export
var levels_unlocked: int

var world_levels : VBoxContainer
var expand_world_button_1 : Button
var expand_world_button_2 : Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var font = preload("res://src/assets/fonts/PixelOperator8.ttf")
	var irange
	if (((world_number + 1) * 12) <= levels_unlocked):
		irange = 12
	else:
		irange = levels_unlocked % 12
	
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	var cont1 : VBoxContainer = VBoxContainer.new()
	cont1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cont1.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	var world_record : WorldRecordContainer = WorldRecordContainer.new()
	world_record.world_number = world_number
	cont1.add_child(world_record)
	
	var expand_world : MarginContainer = MarginContainer.new()
	expand_world.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	expand_world.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	expand_world_button_1 = Button.new()
	expand_world_button_1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	expand_world_button_1.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	expand_world_button_1.add_theme_font_override("font", font)
	expand_world_button_1.add_theme_font_size_override("font_size", 16)
	expand_world_button_1.text = "Show %s Level Scores" % Messages.worldNames[world_number]
	
	world_levels = VBoxContainer.new()
	world_levels.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	world_levels.size_flags_vertical = Control.SIZE_EXPAND_FILL
	for i in range(irange):
		var level_record : LevelRecordContainer = LevelRecordContainer.new()
		level_record.level_number = (world_number * 12) + i
		world_levels.add_child(level_record)
		var sep = HSeparator.new()
		world_levels.add_child(sep)
		
	expand_world_button_2 = Button.new()
	expand_world_button_2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	expand_world_button_2.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	expand_world_button_2.add_theme_font_override("font", font)
	expand_world_button_2.add_theme_font_size_override("font_size", 16)
	expand_world_button_2.text = "Show %s Level Scores" % Messages.worldNames[world_number]
	world_levels.add_child(expand_world_button_2)
	world_levels.visible = false
	
	expand_world_button_1.pressed.connect(self.on_button_pressed)
	expand_world_button_2.pressed.connect(self.on_button_pressed)
	expand_world.add_child(expand_world_button_1)
	cont1.add_child(expand_world)
	var sep = HSeparator.new()
	cont1.add_child(sep)
	
	cont1.add_child(world_levels)
	
	add_child(cont1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_button_pressed():
	expand_world_button_1.release_focus()
	expand_world_button_2.release_focus()
	if world_levels.visible:
		world_levels.visible = false
		expand_world_button_1.text = "Show %s Level Scores" % Messages.worldNames[world_number]
		expand_world_button_2.text = "Show %s Level Scores" % Messages.worldNames[world_number]
	else:
		world_levels.visible = true
		expand_world_button_1.text = "Hide %s Level Scores" % Messages.worldNames[world_number]
		expand_world_button_2.text = "Hide %s Level Scores" % Messages.worldNames[world_number]
