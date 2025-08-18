extends Node

signal KeyObtained(emitter)
signal DoorToggled(emitter)
signal PlayerDied(emitter)
signal ButtonRemapped(action, key)
signal EndGame()
signal ShotFired(emitter)

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
var max_levels = 23
var filepath = "user://save_data.dat"
var saved_times = []

var worldNames = [
	"Tutorial",
	"Spo-cha",
	"WIP",
	"WIP",
	"WIP",
	"WIP",
	"WIP",
	"WIP",
	"WIP",
	"WIP",
	"WIP",
	"WIP"
]

var levelNames = [
	"Move", "Jump", "Dash", "Walls", "Buttons", "Switch", "Levers", "Shooting", "Freeze", "Danger", "Throwing", "Frozen Platform",
	"Long Jump", "High Jump", "Hurdles", "Shotput", "Pole Vault", "100 Meter Dash", "Archery", "Basketball", "Baseball", "Golf", "Football", "Soccer"
]

var ranks = [
	[10, 20, 30, 60, 120], [10, 20, 30, 60, 120], [10, 20, 30, 60, 120], [10, 20, 30, 60, 120], [10, 20, 30, 60, 120], [10, 20, 30, 60, 120], [10, 20, 30, 60, 120], [10, 20, 30, 60, 120], [10, 20, 30, 60, 120], [10, 20, 30, 60, 120], [10, 20, 30, 60, 120], [10, 20, 30, 60, 120], 
	[10, 20, 30, 60, 120], [10, 20, 30, 60, 120], [10, 20, 30, 60, 120], [10, 20, 30, 60, 120], [10, 20, 30, 60, 120], [10, 20, 30, 60, 120], [10, 20, 30, 60, 120], [10, 20, 30, 60, 120], [10, 20, 30, 60, 120], [10, 20, 30, 60, 120], [10, 20, 30, 60, 120], [10, 20, 30, 60, 120], 
]

var rank_assn = ["S", "A", "B", "C", "D", "F", "No Rank Achieved"]

const jump_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/Gameplay/3. Movement/Jump_18.wav")
const dash_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/Gameplay/3. Movement/Jump_4.wav")
const airdash_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/Gameplay/3. Movement/Jump_6.wav")
const freeze_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/Gameplay/5. Collectibles/Collectibles_8.wav")
const shoot_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/Gameplay/6. Bullets & Powerups/Bullet_3.wav")
const throw_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/Gameplay/3. Movement/Jump_1.wav")
const interact_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/Gameplay/6. Bullets & Powerups/Powerup_4.wav")
const die_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/Gameplay/2. Loose/Loose_13.wav")
const clear_sound = preload("res://src/assets/HALFTONE SFX Pack LITE/Gameplay/1. Win/Win_2.wav")

func _ready() -> void:
	# check if save data exists
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file == null:
		var err = FileAccess.get_open_error()
		if err == ERR_FILE_NOT_FOUND:
			# create new save data
			file = FileAccess.open(filepath, FileAccess.WRITE)
			var times = []
			times.resize(max_levels + 1)
			times.fill(5999999)
			file.store_var(times)
			file.close()
			saved_times = times
			print("1")
	else:
		# load saved times
		var read_times = file.get_var()
		if typeof(read_times) == TYPE_DICTIONARY:
			saved_times.resize(max_levels + 1)
			saved_times.fill(5999999)
			# convert to new list format
			for key in read_times.keys():
				var level_num : int = int(key.substr(5))
				saved_times[level_num] = read_times[key]
		else:
			saved_times = read_times
		file.close()
		print("2")
