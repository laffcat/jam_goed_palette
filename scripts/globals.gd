extends Node


var is_paused := false
signal paused
signal unpaused

const HALF_SCR = Vector2(240, 160)

var main : Node2D
var player : CharacterBody2D
var cursor : Cursor

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if !is_paused:
			is_paused = true
			paused.emit()
		else:
			is_paused = false
			unpaused.emit()
