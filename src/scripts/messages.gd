extends Node

signal KeyObtained(emitter)
signal DoorOpened(emitter)
signal PlayerDied(emitter)
signal ButtonRemapped(action, key)
signal EndGame()
signal StartGame()

var rebinds = {}
