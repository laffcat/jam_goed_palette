class_name Cursor
extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.cursor = self


func _input(event):
	if event is InputEventMouseMotion:
		global_position = event.position - Globals.HALF_SCR
