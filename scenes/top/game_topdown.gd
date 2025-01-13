extends Node2D



func _ready() -> void:
	randomize()
	Globals.main = self
	Globals.menu_current = null
