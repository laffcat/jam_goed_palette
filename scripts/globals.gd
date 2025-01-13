extends Node


var is_paused := false
signal paused
signal unpaused

const HALF_SCR = Vector2(240, 160)

var main : Node2D
var player : CharacterBody2D
var cursor : Cursor

#var menus_active := false
var menu_current = null:
	set(new):
		if menu_current != null:
			menu_current.deactivate()
		if new != null:
			new.activate()
		menu_current = new
			
			
#var menu_cursor_current = null

func _input(event: InputEvent):
	if menu_current != null:
		menu_current.receive_input(event)
	if event.is_action_pressed("pause"):
		if !is_paused:
			is_paused = true
			paused.emit()
		else:
			is_paused = false
			unpaused.emit()
		
