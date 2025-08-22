extends MarginContainer

class_name WorldRecordContainer
@export
var world_number: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size_flags_horizontal = Control.SIZE_FILL
	size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var box : HBoxContainer = HBoxContainer.new()
	var sep : VSeparator = VSeparator.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.size_flags_horizontal = Control.SIZE_FILL
	box.size_flags_vertical = Control.SIZE_FILL
	var left : Label = Label.new()
	var font = preload("res://src/assets/fonts/PixelOperator8.ttf")
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.size_flags_vertical = Control.SIZE_FILL
	left.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	left.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	left.add_theme_font_override("font", font)
	left.add_theme_font_size_override("font_size", 16)
	left.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	var right : Label = Label.new()
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.size_flags_vertical = Control.SIZE_FILL
	right.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	right.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	right.add_theme_font_override("font", font)
	right.add_theme_font_size_override("font_size", 16)
	
	var rank : Label = Label.new()
	rank.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rank.size_flags_vertical = Control.SIZE_FILL
	rank.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	rank.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	rank.add_theme_font_override("font", font)
	rank.add_theme_font_size_override("font_size", 16)
	
	var worldName = Messages.worldNames[world_number]
	left.text = "\nWorld: %s\n" % [worldName]
	
	var start_range = world_number * 12
	var end_range = min(((world_number + 1) * 12), (Messages.max_levels + 1))
	var ms = 0
	var cleared = true
	var rank_threshold = 0
	for i in range(start_range, end_range):
		var level_time = Messages.get_stored_level_time(i)
		if level_time == 5999999:
			cleared = false
			break
		else:
			ms += level_time
			rank_threshold += Messages.get_rank_threshold(i)
	
	rank.text = "F"
	for i in range(Messages.rank_changes.size()):
		if ms < (rank_threshold * Messages.rank_changes[i] * 1000):
			rank.text = Messages.rank_assn[i]
			break
	
	if cleared:
		right.text = "\n" + Messages.get_readable_time(ms) + "\n"
	else:
		right.text = "\nClear all levels in %s to obtain a world high score!\n" % worldName
		right.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	if cleared:
		var boxRight : HBoxContainer = HBoxContainer.new()
		boxRight.alignment = BoxContainer.ALIGNMENT_CENTER
		boxRight.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		boxRight.size_flags_vertical = Control.SIZE_FILL
		var sep2 : VSeparator = VSeparator.new()
		boxRight.add_child(right)
		boxRight.add_child(sep2)
		boxRight.add_child(rank)
		
		box.add_child(left)
		box.add_child(sep)
		box.add_child(boxRight)
	else:
		box.add_child(left)
		box.add_child(sep)
		box.add_child(right)
	add_child(box)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
