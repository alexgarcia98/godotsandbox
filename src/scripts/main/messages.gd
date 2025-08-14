extends Node

signal KeyObtained(emitter)
signal DoorToggled(emitter)
signal PlayerDied(emitter)
signal ButtonRemapped(action, key)
signal EndGame()
signal ShotFired(emitter)

signal LevelEnded()
signal LevelStarted(level)

# UI Interactions
signal PreviousLevel()
signal NextLevel()
signal Restart()
signal ResetTimes()
signal MainMenu()
signal WorldSelect()
signal LoadLevel()
signal LoadWorld()

var rebinds = {}
