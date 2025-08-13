extends Node

signal KeyObtained(emitter)
signal DoorOpened(emitter)
signal PlayerDied(emitter)
signal ButtonRemapped(action, key)
signal EndGame()
signal StartGame()
signal ShotFired(emitter)

signal LevelEnded()
signal LevelStarted(level)

# UI Interactions
signal PreviousLevel()
signal NextLevel()
signal Restart()
signal ResetTimes()
signal MainMenu()

var rebinds = {}
