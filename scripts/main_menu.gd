extends Node2D


@export var submenus : Array[Node2D]
@export var color_unselected : Color

enum Sub {TITLE, OPTIONS, CREDITS}
var current_submenu : Sub :
	set(new_sub):
		if active:
			submenus[current_submenu].deactivate()
			submenus[new_sub].activate()
			current_submenu = new_sub
@onready var current_button : Node2D = $MenuTitle/MainBtnPlay :
	set(new_btn):
		if active:
			current_button.modulate = color_unselected
			current_button = new_btn
			current_button.modulate = Color.WHITE

var active := false

func activate():
	active = true
	visible = true
	current_submenu = Sub.TITLE
	
func deactivate():
	visible = false	
	
func receive_input(event: InputEvent):
	match current_submenu:
		Sub.TITLE:
			if event.is_action_pressed("up"):
				current_button = current_button.up
			if event.is_action_pressed("down"):
				current_button = current_button.down
			if event.is_action_pressed("jump"):
				match current_button.btn_name:
					"Play":
						get_tree().change_scene_to_file("res://scenes/top/game_topdown.tscn")
					"Options":
						current_submenu = Sub.OPTIONS
					"Credits":
						current_submenu = Sub.CREDITS
		Sub.OPTIONS:
			if event.is_action_pressed("jump"):
				current_submenu = Sub.TITLE
		Sub.CREDITS:
			if event.is_action_pressed("jump"):
				current_submenu = Sub.TITLE



func _ready(): Globals.menu_current = self
