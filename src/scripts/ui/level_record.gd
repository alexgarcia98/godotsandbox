extends MarginContainer

class_name LevelRecordContainer
@export
var level_number: int

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
	
	var worldName = Messages.worldNames[level_number / 12]
	var levelName
	if level_number < Messages.levelNames.size():
		levelName = Messages.levelNames[level_number]
	else:
		levelName = str((level_number % 12) + 1)
	left.text = "\n%s: %s\n" % [worldName, levelName]
	
	
	var ms
	if Messages.saved_times.size() <= level_number:
		ms = 5999999
		Messages.saved_times.append(5999999)
		right.text = "\nNo Time Set\n"
	else:
		ms = Messages.saved_times[level_number]
		if ms == 5999999:
			right.text = "\nNo Time Set\n"
		else:
			var sec = floor(ms / 1000)
			var minute = floor(sec / 60)
			right.text = "\n%02d:%02d.%03d\n" % [minute, (sec % 60), (ms % 1000)]
	
	rank.text = "F"
	for i in range(Messages.rank_changes.size()):
		if ms < (Messages.ranks[level_number] * Messages.rank_changes[i] * 1000):
			rank.text = Messages.rank_assn[i]
			break
	
	if ms == 5999999:
		rank.text = "None"
	
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
	add_child(box)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
