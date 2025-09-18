extends Node

signal KeyObtained(emitter)
signal DoorToggled(emitter)
signal PlayerDied(emitter)
signal PlayerRevived(emitter)
signal PlayerVulnerable(emitter)
signal SetRedPlayerRespawn(pos)
signal SetGreenPlayerRespawn(pos)
signal KeyboardRemapped(action, key)
signal JoypadButtonRemapped(action, button)
signal JoypadAxisRemapped(action, button, value)
signal EndGame()
signal ShotFired(emitter)
signal TargetHit()

signal LevelEnded()
signal LevelStarted(level)
signal BeginLevel(level)

# UI Interactions
signal PreviousLevel()
signal NextLevel()
signal Restart()
signal ResetTimes()
signal ResetLevelTime(level)
signal MainMenu()
signal WorldSelect()
signal LoadLevel()
signal LoadWorld()
signal UnlockLevels()
signal LockLevels()
signal ResetControls()

var rebinds = {}
var controller_rebinds = {}
var max_levels = 143
var filepath = "user://save_data.dat"
var new_filepath = "user://save_data_v2.dat"
var saved_times = []

var levels_unlocked: int = 1
var levels_unlocked_filepath = "user://levels_unlocked.dat"

var control_names = {
	"Joypad Motion on Axis 0 (Left Stick X-Axis, Joystick 0 X-Axis) with Value -1.00": "Left Stick Left",
	"Joypad Motion on Axis 0 (Left Stick X-Axis, Joystick 0 X-Axis) with Value 1.00": "Left Stick Right",
	"Joypad Motion on Axis 1 (Left Stick Y-Axis, Joystick 0 Y-Axis) with Value -1.00": "Left Stick Up",
	"Joypad Motion on Axis 1 (Left Stick Y-Axis, Joystick 0 Y-Axis) with Value 1.00": "Left Stick Down",
	"Joypad Motion on Axis 2 (Right Stick X-Axis, Joystick 1 X-Axis) with Value -1.00": "Right Stick Left",
	"Joypad Motion on Axis 2 (Right Stick X-Axis, Joystick 1 X-Axis) with Value 1.00": "Right Stick Right",
	"Joypad Motion on Axis 3 (Right Stick Y-Axis, Joystick 1 Y-Axis) with Value -1.00": "Right Stick Up",
	"Joypad Motion on Axis 3 (Right Stick Y-Axis, Joystick 1 Y-Axis) with Value 1.00": "Right Stick Down",
	"Joypad Motion on Axis 4 (Joystick 2 X-Axis, Left Trigger, Sony L2, Xbox LT) with Value 1.00": "Left Trigger",
	"Joypad Motion on Axis 5 (Joystick 2 Y-Axis, Right Trigger, Sony R2, Xbox RT) with Value 1.00": "Right Trigger"
}

# ordered list for worldsddddddddd
var worldNames = [
	"Getting Started",
	"Mirror",
	"Around the World",
	"The Movement",
	"Foodieland",
	"Shooting Practice",
	"Spo-cha",
	"X-Ray",
	"Retro Games",
	"Helping Hand",
	"Thread the Needle",
	"Endgame"
]

# level info structure:
# key: level name
# value: [save slot / level file number, rank threshold]
var levelInfo = {
	"Move": [0, 5], "Jump": [1, 5], "Dash": [2, 5], "Walls": [3, 8], "Buttons": [4, 5], "Switch": [5, 5], 
	"Levers": [6, 8], "Shooting": [7, 8], "Advance": [8, 10], "Danger": [9, 8], "Throwing": [10, 5], "Freeze": [11, 10],
	"Long Jump": [12, 8], "High Jump": [13, 8], "Hurdles": [14, 12], "Shotput": [15, 10], "Pole Vault": [16, 12], "100 Meter Dash": [17, 10], 
	"Archery": [18, 10], "Basketball": [19, 10], "Baseball": [20, 20], "Golf": [21, 10], "Football": [22, 10], "Soccer": [23, 10],
	"One-Way Street": [24, 5], "Two-Way Street": [25, 5], "Double Dash": [26, 10], "Waves": [27, 15], "Tight Squeeze": [28, 12], "Trees": [29, 15], 
	"Simon the Digger": [30, 30], "The Big One": [31, 15], "Good Luck": [32, 15], "Popo and Nana": [33, 15], "Parting Shot": [34, 20], "Exam-E": [35, 30],
	"Reunion": [36, 2], "Meetup": [37, 5], "Small Jumps": [38, 5], "Big Jumps": [39, 8], "Twin Peaks": [40, 5], "Summit": [41, 5], 
	"Airkick Turn": [42, 10], "Drop Chute": [43, 10], "U-Turn": [44, 20], "Escalator": [45, 5], "Big Dogs": [46, 10], "Exam-D": [47, 25],
	"Uber": [48, 8], "Elevator": [49, 8], "Timed Doors": [50, 5], "My Back!": [51, 4], "Split Ascent": [52, 10], "Floaters": [53, 12], 
	"Not Flappy Bird": [54, 8], "Quick Gap": [55, 12], "The Walls Are Moving!": [56, 10], "Chaos": [57, 10], "The Wave": [58, 4], "Enjoy the Ride": [59, 30],
	"Pong": [60, 17], "Space Invaders": [61, 6], "Pac-Man": [62, 20], "Donkey Kong": [63, 25], "Bomberman": [64, 25], "Tetris": [65, 15], 
	"Super Mario Bros.": [66, 20], "Mega Man 2": [67, 10], "Street Fighter 2": [68, 20], "Sonic the Hedgehog 2": [69, 5], "Doom": [70, 30], "Pokemon Red": [71, 10],
	"Break the Targets!!": [72, 10], "Moving Shot": [73, 8], "Shoot the Gap": [74, 25], "Precision Shooting": [75, 20], "Drop Shot": [76, 5], "It's the Breakout System": [77, 20], 
	"Rapunzel": [78, 30], "Moving Targets": [79, 30], "Shooting Blind": [80, 30], "Target Smash! Lv.1": [81, 20], "Fox Target Test": [82, 30], "Shoot Your Shot": [83, 30],
	"Mirror?": [84, 5], "Diving Partners": [85, 5], "Altergate": [86, 20], "Rescue the Princess": [87, 10], "Heads Up": [88, 10], "Watch Your Feet!": [89, 7], 
	"Scaffolds": [90, 12], "I'll Go First": [91, 30], "Lights Out": [92, 45], "Jailbreak": [93, 20], "Wall Break": [94, 30], "Escape": [95, 8],
	"Walking on Air": [96, 4], "Invisible": [97, 8], "Mind the Gap": [98, 5], "Walls?": [99, 8], "Black Mold": [100, 8], "3hai": [101, 7], 
	"Firewall": [102, 10], "Muscle Memory": [103, 8], "Find the Cheese": [104, 20], "Clear Shot": [105, 15], "Also Not Flappy Bird": [106, 8], "Potholes": [107, 17],
	"Golden Gate Bridge": [108, 7], "Mt. Fuji": [109, 7], "The Pyramids of Giza": [110, 7], "Christ the Redeemer": [111, 10], "Eiffel Tower": [112, 7], "Sydney Opera House": [113, 7], 
	"Taj Mahal": [114, 8], "Stonehenge": [115, 7], "Leaning Tower of Pisa": [116, 8], "The Colosseum": [117, 7], "Great Wall of China": [118, 7], "Earth": [119, 18],
	"Dim Sum": [120, 10], "Samosas": [121, 7], "Macarons": [122, 10], "Tacos": [123, 7], "Lechon": [124, 7], "Jamón": [125, 10], 
	"Bibimbap": [126, 10], "Sushi": [127, 7], "Spaghetti": [128, 10], "Thai Iced Tea": [129, 10], "Barbecue": [130, 7], "Dondurma": [131, 20],
	"Sans": [132, 8], "Madness": [133, 10], "The Bam Special": [134, 10], "Hold On Tight": [135, 30], "Rat Poison": [136, 15], "We Were Drifting": [137, 10], 
	"Strafe": [138, 20], "Ice Wall": [139, 25], "Target Smash! Lv.5": [140, 20], "PEAK": [141, 5], "Exam-F": [142, 45], "Twice Climbers": [143, 5]
}

# lists are ordered for level select
var worldLevels = {
	"Getting Started": ["Move", "Jump", "Dash", "Walls", "Buttons", "Switch", 
		"Levers", "Shooting", "Danger", "Throwing", "Freeze", "Advance"],
	"Spo-cha": ["Long Jump", "High Jump", "Hurdles", "Shotput", "Pole Vault", "100 Meter Dash", 
		"Archery", "Basketball", "Baseball", "Golf", "Football", "Soccer"],
	"Thread the Needle": ["One-Way Street", "Two-Way Street", "Double Dash", "Waves", "Simon the Digger", "The Big One", 
		"Tight Squeeze", "Trees", "Popo and Nana", "Parting Shot", "Good Luck", "Exam-E"],
	"Mirror": ["Reunion", "Meetup", "Small Jumps", "Big Jumps", "Twin Peaks", "Summit", 
		"Drop Chute", "Airkick Turn", "Escalator", "U-Turn", "Big Dogs", "Exam-D"],
	"The Movement": ["Uber", "Elevator", "Timed Doors", "My Back!", "Split Ascent", "Floaters", 
		"Not Flappy Bird", "Quick Gap", "The Walls Are Moving!", "Chaos", "The Wave", "Enjoy the Ride"],
	"Retro Games": ["Pong", "Space Invaders", "Pac-Man", "Donkey Kong", "Bomberman", "Tetris", 
		"Super Mario Bros.", "Mega Man 2", "Street Fighter 2", "Sonic the Hedgehog 2", "Doom", "Pokemon Red"],
	"Shooting Practice": ["Break the Targets!!", "Moving Shot", "Shoot the Gap", "Precision Shooting", "Drop Shot", "It's the Breakout System", 
		"Rapunzel", "Moving Targets", "Shooting Blind", "Target Smash! Lv.1", "Fox Target Test", "Shoot Your Shot"],
	"Helping Hand": ["Mirror?", "Diving Partners", "Altergate", "Rescue the Princess", "Heads Up", "Watch Your Feet!", 
		"Scaffolds", "I'll Go First", "Lights Out", "Jailbreak", "Wall Break", "Escape"],
	"X-Ray": ["Walking on Air", "Invisible", "Also Not Flappy Bird", "Potholes", "Clear Shot", "Mind the Gap",
		"Walls?", "3hai", "Firewall", "Black Mold", "Muscle Memory", "Find the Cheese"],
	"Around the World": ["Golden Gate Bridge", "Mt. Fuji", "The Pyramids of Giza", "Christ the Redeemer", "Eiffel Tower", "Sydney Opera House", 
		"Taj Mahal", "Stonehenge", "Leaning Tower of Pisa", "The Colosseum", "Great Wall of China", "Earth"],
	"Foodieland": ["Dim Sum", "Jamón", "Samosas", "Sushi", "Tacos", "Spaghetti",
		"Bibimbap", "Barbecue", "Lechon", "Thai Iced Tea", "Macarons", "Dondurma"],
	"Endgame": ["PEAK", "Sans", "Hold On Tight", "Target Smash! Lv.5", "Rat Poison", "Madness", 
		"Ice Wall", "The Bam Special", "Strafe", "We Were Drifting", "Exam-F", "Twice Climbers"],
}

var rank_changes = [1, 1.25, 2, 3, 10]

var rank_assn = ["S", "A", "B", "C", "D", "F", "No Rank Achieved"]

var rank_color = {"S": "c687f7", "A": "7bf7f6", "B": "d2d2d2", "C": "e8b904", "D": "9e9ea8", "F": "c98645", "None": "ffffff"}

const jump_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/Gameplay/3. Movement/Jump_18.wav")
const dash_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/Gameplay/3. Movement/Jump_4.wav")
const airdash_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/Gameplay/3. Movement/Jump_6.wav")
const pivot_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/Gameplay/3. Movement/Jump_22.wav")
const freeze_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/Gameplay/5. Collectibles/Collectibles_8.wav")
const thaw_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/Gameplay/5. Collectibles/Collectibles_7.wav")
const shoot_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/Gameplay/6. Bullets & Powerups/Bullet_3.wav")
const throw_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/Gameplay/3. Movement/Jump_1.wav")
const interact_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/Gameplay/6. Bullets & Powerups/Powerup_4.wav")
const pickup_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/Gameplay/5. Collectibles/Collectibles_1.wav")
const die_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/Gameplay/2. Loose/Loose_13.wav")
const clear_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/Gameplay/1. Win/Win_2.wav")
const stage_select_pressed_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/UI/1. Buttons/Button_17.wav")
const progress_button_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/Gameplay/5. Collectibles/Collectibles_2.wav")
const return_button_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/UI/1. Buttons/Button_12.wav")
const high_button_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/UI/1. Buttons/Button_4.wav")
const ring_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/Gameplay/5. Collectibles/Collectibles_5.wav")


var audio: AudioStreamPlayer2D

func _init() -> void:
	audio = AudioStreamPlayer2D.new()
	add_child(audio)
	audio.bus = "UI"
	connect("ResetTimes", reset_all_level_times)

func _ready() -> void:
	# check if save data exists
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file == null:
		var err = FileAccess.get_open_error()
		if err == ERR_FILE_NOT_FOUND:
			# create new save data
			file = FileAccess.open(filepath, FileAccess.WRITE)
			var times = []
			times.resize(worldNames.size() * 12)
			times.fill(5999999)
			file.store_var(times)
			file.close()
			saved_times = times
	else:
		# load saved times
		var read_times = file.get_var()
		if typeof(read_times) == TYPE_DICTIONARY:
			saved_times.resize(worldNames.size() * 12)
			saved_times.fill(5999999)
			# convert to new list format
			for key in read_times.keys():
				var level_num : int = int(key.substr(5))
				saved_times[level_num] = read_times[key]
		else:
			saved_times = read_times
			if saved_times.size() < (worldNames.size() * 12):
				saved_times.resize(worldNames.size() * 12)
				for i in range(saved_times.size()):
					if saved_times[i] == null:
						saved_times[i] = 5999999
		file.close()
	
	var file2 = FileAccess.open(levels_unlocked_filepath, FileAccess.READ)
	if file2 == null:
		var err = FileAccess.get_open_error()
		if err == ERR_FILE_NOT_FOUND:
			# create new save data
			file2 = FileAccess.open(levels_unlocked_filepath, FileAccess.WRITE)
			var unlocked = 1
			file2.store_var(unlocked)
			file2.close()
			levels_unlocked = unlocked
	else:
		# load levels unlocked
		levels_unlocked = file2.get_var()
		file2.close()

func unlock_next_level(current_index):
	if (current_index + 2) > levels_unlocked:
		levels_unlocked = min(current_index + 2, max_levels + 1)
		var write_file = FileAccess.open(levels_unlocked_filepath, FileAccess.WRITE)
		write_file.store_var(levels_unlocked)
		write_file.close()

func unlock_levels():
	levels_unlocked = max_levels + 1
	var write_file = FileAccess.open(levels_unlocked_filepath, FileAccess.WRITE)
	write_file.store_var(levels_unlocked)
	write_file.close()

func lock_levels():
	levels_unlocked = 1
	var write_file = FileAccess.open(levels_unlocked_filepath, FileAccess.WRITE)
	write_file.store_var(levels_unlocked)
	write_file.close()

func get_save_index(current_index) -> int:
	var worldName = worldNames[current_index / 12]
	var levelName = worldLevels[worldName][current_index % 12]
	var saveIndex = levelInfo[levelName][0]
	return saveIndex

func get_stored_level_time(current_index) -> int:
	var saveIndex = get_save_index(current_index)
	var ms = saved_times[saveIndex]
	return ms
	
func get_readable_time(ms) -> String:
	var sec = floor(ms / 1000)
	var minute = floor(sec / 60)
	return "%02d:%02d.%03d" % [minute, (sec % 60), (ms % 1000)]

func get_readable_stored_level_time(current_index) -> String:
	var saveIndex = get_save_index(current_index)
	var ms = saved_times[saveIndex]
	if ms == 5999999:
		return "No Time Set"
	else:
		var sec = floor(ms / 1000)
		var minute = floor(sec / 60)
		return "%02d:%02d.%03d" % [minute, (sec % 60), (ms % 1000)]

func get_stored_rank(current_index) -> String:
	var ms = saved_times[get_save_index(current_index)]
	return get_rank_from_time(current_index, ms)

func get_rank_threshold(current_index) -> int:
	var worldName = worldNames[current_index / 12]
	var levelName = worldLevels[worldName][current_index % 12]
	var levelRankThreshold = levelInfo[levelName][1]
	return levelRankThreshold

func get_rank_from_time(current_index, ms) -> String:
	var worldName = worldNames[current_index / 12]
	var levelName = worldLevels[worldName][current_index % 12]
	var saveIndex = levelInfo[levelName][0]
	var levelRankThreshold = levelInfo[levelName][1]
	var rank = "F"
	for i in range(rank_changes.size()):
		if ms < (levelRankThreshold * rank_changes[i] * 1000):
			rank = rank_assn[i]
			break
	
	if ms == 5999999:
		rank = "None"
	
	return rank

func get_rank_color(rank):
	return rank_color[rank]

func get_world_level_name(current_index) -> String:
	var worldName = worldNames[current_index / 12]
	var levelName = worldLevels[worldName][current_index % 12]
	return "%s: %s" % [worldName, levelName]
	
func reset_level_time(index):
	var save_index = get_save_index(index)
	saved_times[save_index] = 5999999
	var write_file = FileAccess.open(filepath, FileAccess.WRITE)
	write_file.store_var(saved_times)
	write_file.close()

func update_level_time(index, level_time_ms):
	var save_index = get_save_index(index)
	if level_time_ms < saved_times[save_index]:
		saved_times[save_index] = level_time_ms
		var write_file = FileAccess.open(filepath, FileAccess.WRITE)
		write_file.store_var(saved_times)
		write_file.close()

func reset_all_level_times():
	var file = FileAccess.open(filepath, FileAccess.WRITE)
	var times = []
	times.resize(worldNames.size() * 12)
	times.fill(5999999)
	file.store_var(times)
	file.close()
	saved_times = times

func get_event_text(event):
	var text_event = event.as_text()
	if text_event.ends_with(" (Physical)"):
		text_event = text_event.substr(0, (text_event.length() - 11))
	elif event is InputEventJoypadButton:
		var ind1 = text_event.find("(")
		var ind2 = text_event.find(")")
		var ind3 = text_event.find(",")
		if ind3 == -1:
			text_event = text_event.substr(ind1 + 1, (ind2 - ind1) - 1)
		else:
			text_event = text_event.substr(ind1 + 1, (ind3 - ind1) - 1)
	elif event is InputEventJoypadMotion:
		if control_names.has(text_event):
			text_event = control_names[text_event]
	return text_event

func erase_keyboard_events(action):
	var events = InputMap.action_get_events(action)
	for event in events:
		if event is InputEventKey:
			InputMap.action_erase_event(action, event)

func erase_controller_events(action):
	var events = InputMap.action_get_events(action)
	for event in events:
		if event is InputEventJoypadButton:
			InputMap.action_erase_event(action, event)
		elif event is InputEventJoypadMotion:
			InputMap.action_erase_event(action, event)
