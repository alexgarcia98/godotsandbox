extends TileMapLayer

@onready var play: Button = $AllUI/UI/MarginContainer/HBoxContainer/Play
@onready var records: Button = $AllUI/UI/MarginContainer/HBoxContainer/Records
@onready var debug: Button = $AllUI/UI/MarginContainer/HBoxContainer/Debug
@onready var dimmer: ColorRect = $Dimmer
@onready var debug_window: Control = $AllUI/DebugWindow
@onready var records_window: Control = $AllUI/RecordsWindow
@onready var help_window: Control = $AllUI/HelpWindow
@onready var help_text: Label = $AllUI/DebugWindow/MarginContainer/VBoxContainer/MarginContainer/PanelContainer/HelpText
@onready var level_records: VBoxContainer = $AllUI/RecordsWindow/MarginContainer/VBoxContainer/PanelContainer2/ScrollContainer/LevelRecords
@onready var total_high_score: Label = $AllUI/RecordsWindow/MarginContainer/VBoxContainer/HBoxContainer2/PanelContainer/TotalHighScore
@onready var export: Button = $AllUI/RecordsWindow/MarginContainer/VBoxContainer/HBoxContainer2/Export

@onready var unlock_levels: Button = $AllUI/DebugWindow/MarginContainer/VBoxContainer/HBoxContainer/UnlockLevels
@onready var lock_levels: Button = $AllUI/DebugWindow/MarginContainer/VBoxContainer/HBoxContainer/LockLevels
@onready var reset_records: Button = $AllUI/DebugWindow/MarginContainer/VBoxContainer/HBoxContainer2/ResetRecords
@onready var reset_controls: Button = $AllUI/DebugWindow/MarginContainer/VBoxContainer/HBoxContainer2/ResetControls
@onready var import_save: Button = $AllUI/DebugWindow/MarginContainer/VBoxContainer/HBoxContainer3/ImportSave
@onready var export_save: Button = $AllUI/DebugWindow/MarginContainer/VBoxContainer/HBoxContainer3/ExportSave
@onready var file_dialog: FileDialog = $AllUI/DebugWindow/FileDialog
@onready var file_dialog_2: FileDialog = $AllUI/DebugWindow/FileDialog2
@onready var basics_button: Button = $AllUI/HelpWindow/MarginContainer/VBoxContainer/HBoxContainer4/Basics
@onready var basics: MarginContainer = $AllUI/HelpWindow/MarginContainer/VBoxContainer/Basics
@onready var mechanics: MarginContainer = $AllUI/HelpWindow/MarginContainer/VBoxContainer/Mechanics
@onready var interaction: MarginContainer = $AllUI/HelpWindow/MarginContainer/VBoxContainer/Interaction
@onready var other: MarginContainer = $AllUI/HelpWindow/MarginContainer/VBoxContainer/Other
@onready var how_to_play: Button = $AllUI/UI/MarginContainer/HBoxContainer/HowToPlay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dimmer.visible = false
	dimmer.self_modulate.a = 0.5
	debug_window.visible = false
	records_window.visible = false
	help_window.visible = false
	help_text.text = ""
	populate_records()
	set_up_file_dialog()
	play.grab_focus.call_deferred()
	Messages.connect("ImportSuccess", on_import_success)
	Messages.connect("ImportFailure", on_import_failure)
	Messages.connect("ExportSuccess", on_export_success)
	Messages.connect("ExportFailure", on_export_failure)

func populate_records():
	var mainScene = get_parent()
	var children = level_records.get_children()
	for child in children:
		child.queue_free()
	var sep : HSeparator = HSeparator.new()
	level_records.add_child(sep)
	for j in range(12):
		if Messages.unlocked_levels[Messages.worldNames[j]] == 0:
			continue
		var expand_record : ExpandRecordContainer = ExpandRecordContainer.new()
		expand_record.world_number = j
		level_records.add_child(expand_record)
	var total_time : int = 0
	var all_cleared : bool = true
	for i in range(Messages.max_levels + 1):
		var level = Messages.get_stored_level_time(i)
		if level == 5999999:
			all_cleared = false
			break
		total_time += level
	if all_cleared:
		var sec = floor(total_time / 1000)
		var minute = floor(sec / 60)
		var hour = floor(minute / 60)
		total_high_score.text = "\nTotal High Score: %02d:%02d:%02d.%03d\n" % [
			hour, (minute % 60), (sec % 60), (total_time % 1000)
		]
	else:
		total_high_score.text = "\nClear all available levels to obtain a total high score!\n"

func set_up_file_dialog():
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.filters = ["*.dat ; Save Data File"]
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.title = "Import Save Data"
	file_dialog_2.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	file_dialog_2.filters = ["*.dat ; Save Data File"]
	file_dialog_2.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog_2.title = "Export Save Data"
	file_dialog_2.current_path = "file://"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_pressed() -> void:
	Messages.audio.stream = Messages.high_button_sound
	Messages.audio.play()
	Messages.emit_signal("WorldSelect")

func _on_exit_pressed() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	Messages.emit_signal("EndGame")

func _on_how_to_play_pressed() -> void:
	Messages.audio.stream = Messages.stage_select_pressed_sound
	Messages.audio.play()
	dimmer.visible = true
	help_window.visible = true
	basics.visible = true
	mechanics.visible = false
	interaction.visible = false
	other.visible = false
	basics_button.grab_focus.call_deferred()

func _on_reset_times_pressed() -> void:
	Messages.emit_signal("ResetTimes")

func _on_records_pressed() -> void:
	Messages.audio.stream = Messages.stage_select_pressed_sound
	Messages.audio.play()
	dimmer.visible = true
	records_window.visible = true
	export.grab_focus.call_deferred()

func _on_debug_pressed() -> void:
	Messages.audio.stream = Messages.stage_select_pressed_sound
	Messages.audio.play()
	dimmer.visible = true
	debug_window.visible = true
	unlock_levels.grab_focus.call_deferred()

func _on_debug_window_close_requested() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	dimmer.visible = false
	debug_window.visible = false
	
func _on_records_window_close_requested() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	dimmer.visible = false
	records_window.visible = false

func _on_unlock_levels_pressed() -> void:
	Messages.audio.stream = Messages.high_button_sound
	Messages.audio.play()
	Messages.emit_signal("UnlockLevels")
	help_text.text = "All levels are now available to play"
	populate_records()

func _on_reset_records_pressed() -> void:
	Messages.audio.stream = Messages.high_button_sound
	Messages.audio.play()
	Messages.emit_signal("ResetTimes")
	help_text.text = "All best times have been cleared"

func _on_reset_replays_pressed() -> void:
	Messages.audio.stream = Messages.high_button_sound
	Messages.audio.play()
	Messages.clear_replays()
	help_text.text = "All replays have been cleared"

func _on_reset_controls_pressed() -> void:
	Messages.audio.stream = Messages.high_button_sound
	Messages.audio.play()
	Messages.emit_signal("ResetControls")
	help_text.text = "Controls set to default control scheme"

func _on_lock_levels_pressed() -> void:
	Messages.audio.stream = Messages.high_button_sound
	Messages.audio.play()
	Messages.emit_signal("LockLevels")
	help_text.text = "Level unlocks have been reset"
	populate_records()

func _on_import_save_pressed() -> void:
	Messages.audio.stream = Messages.high_button_sound
	Messages.audio.play()
	if OS.has_feature("web"):
		Messages.import_save_web()
	else:
		file_dialog.popup_centered()

func _on_export_save_pressed() -> void:
	Messages.audio.stream = Messages.high_button_sound
	Messages.audio.play()
	if OS.has_feature("web"):
		Messages.export_save_web("save_backup_%s.dat" % int(floor(Time.get_unix_time_from_system())))
	else:
		file_dialog_2.current_file = "save_backup_%s.dat" % int(floor(Time.get_unix_time_from_system()))
		file_dialog_2.popup_centered()

func on_import_success():
	help_text.text = "Save data successfully imported"
	
func on_import_failure():
	help_text.text = "Save data import failed: Invalid File"
	
func on_export_success():
	help_text.text = "Save data successfully exported"
	
func on_export_failure():
	help_text.text = "Save data export failed"

func _on_unlock_levels_mouse_entered() -> void:
	help_text.text = "Make all levels available to play"

func _on_unlock_levels_mouse_exited() -> void:
	help_text.text = ""

func _on_reset_records_mouse_entered() -> void:
	help_text.text = "Clear best times for ALL levels"

func _on_reset_records_mouse_exited() -> void:
	help_text.text = ""

func _on_lock_levels_mouse_entered() -> void:
	help_text.text = "Return level unlocks to first level only\n(level records are preserved)"

func _on_lock_levels_mouse_exited() -> void:
	help_text.text = ""

func _on_reset_controls_mouse_entered() -> void:
	help_text.text = "Revert controls to default control scheme"

func _on_reset_controls_mouse_exited() -> void:
	help_text.text = ""
	
func _on_unlock_levels_focus_entered() -> void:
	help_text.text = "Make all levels available to play"

func _on_unlock_levels_focus_exited() -> void:
	help_text.text = ""

func _on_reset_records_focus_entered() -> void:
	help_text.text = "Clear best times for ALL levels"

func _on_reset_records_focus_exited() -> void:
	help_text.text = ""

func _on_reset_replays_focus_entered() -> void:
	help_text.text = "Clear saved replays for ALL levels"

func _on_reset_replays_focus_exited() -> void:
	help_text.text = ""

func _on_reset_replays_mouse_entered() -> void:
	help_text.text = "Clear saved replays for ALL levels"

func _on_reset_replays_mouse_exited() -> void:
	help_text.text = ""

func _on_lock_levels_focus_entered() -> void:
	help_text.text = "Return level unlocks to first level only\n(level records are preserved)"

func _on_lock_levels_focus_exited() -> void:
	help_text.text = ""

func _on_reset_controls_focus_entered() -> void:
	help_text.text = "Revert controls to default control scheme"

func _on_reset_controls_focus_exited() -> void:
	help_text.text = ""

func _on_exit_debug_focus_entered() -> void:
	help_text.text = "Close debug menu"

func _on_exit_debug_focus_exited() -> void:
	help_text.text = ""

func _on_exit_debug_mouse_entered() -> void:
	help_text.text = "Close debug menu"

func _on_exit_debug_mouse_exited() -> void:
	help_text.text = ""

func _on_import_save_focus_entered() -> void:
	help_text.text = "Import local save data file"

func _on_import_save_focus_exited() -> void:
	help_text.text = ""

func _on_import_save_mouse_entered() -> void:
	help_text.text = "Import local save data file"

func _on_import_save_mouse_exited() -> void:
	help_text.text = ""

func _on_export_save_focus_entered() -> void:
	help_text.text = "Download save data file"

func _on_export_save_focus_exited() -> void:
	help_text.text = ""

func _on_export_save_mouse_entered() -> void:
	help_text.text = "Download save data file"

func _on_export_save_mouse_exited() -> void:
	help_text.text = ""

func _on_export_pressed() -> void:
	# generate text
	var mainScene = get_parent()
	var record_text = ""
	
	# generate total high score
	var total_time : int = 0
	var all_cleared : bool = true
	for i in range(Messages.max_levels + 1):
		var level = Messages.get_stored_level_time(i)
		if level == 5999999:
			all_cleared = false
			break
		total_time += level
	if all_cleared:
		var sec = floor(total_time / 1000)
		var minute = floor(sec / 60)
		var hour = floor(minute / 60)
		record_text += "Total High Score: %02d:%02d:%02d.%03d\n\n" % [
			hour, (minute % 60), (sec % 60), (total_time % 1000)
		]
	else:
		record_text += "Clear all available levels to obtain a total high score!\n\n"
	
	# generate world subsection scores
	for j in range(12):
		var world_number = j
		var worldName = Messages.worldNames[world_number]
		if Messages.unlocked_levels[worldName] == 0:
			continue
		record_text += "%s: " % [worldName]
		
		var start_range = world_number * 12
		var end_range = min(((world_number + 1) * 12), Messages.max_levels + 1)
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
		
		var rank = "F"
		for i in range(Messages.rank_changes.size()):
			if ms < (rank_threshold * Messages.rank_changes[i] * 1000):
				rank = Messages.rank_assn[i]
				break
		
		if cleared:
			record_text += Messages.get_readable_time(ms) + "\n"
		else:
			record_text += "Clear all levels in %s to obtain a world high score!\n" % worldName
		
	record_text += "\n"
	
	for i in range(Messages.max_levels + 1):
		var worldName = Messages.worldNames[i / 12]
		if Messages.unlocked_levels[worldName] == 0:
			continue
		var levelName = Messages.worldLevels[worldName][i % 12]
		record_text += levelName
		var level_time = Messages.get_stored_level_time(i)
		record_text += ": " + Messages.get_readable_stored_level_time(i) + "\n"
	
	DisplayServer.clipboard_set(record_text)

func _on_exit_debug_pressed() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	dimmer.visible = false
	debug_window.visible = false
	debug.grab_focus.call_deferred()

func _on_exit_records_pressed() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	dimmer.visible = false
	records_window.visible = false
	records.grab_focus.call_deferred()

func _on_file_dialog_file_selected(fpath: String) -> void:
	Messages.import_save(fpath)

func _on_file_dialog_2_file_selected(fpath: String) -> void:
	Messages.export_save(fpath)


func _on_basics_pressed() -> void:
	basics.visible = true
	mechanics.visible = false
	interaction.visible = false
	other.visible = false

func _on_mechanics_pressed() -> void:
	basics.visible = false
	mechanics.visible = true
	interaction.visible = false
	other.visible = false

func _on_interactables_pressed() -> void:
	basics.visible = false
	mechanics.visible = false
	interaction.visible = true
	other.visible = false

func _on_other_pressed() -> void:
	basics.visible = false
	mechanics.visible = false
	interaction.visible = false
	other.visible = true

func _on_exit_help_pressed() -> void:
	Messages.audio.stream = Messages.return_button_sound
	Messages.audio.play()
	dimmer.visible = false
	help_window.visible = false
	how_to_play.grab_focus.call_deferred()
