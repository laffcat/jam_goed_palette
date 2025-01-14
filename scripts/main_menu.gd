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
	pass
	#visible = false	
	
func receive_input(event: InputEvent):
	match current_submenu:
		Sub.TITLE:
			if event.is_action_pressed("up"):
				current_button = current_button.up
				$SFX/Boop.play()
			if event.is_action_pressed("down"):
				current_button = current_button.down
				$SFX/Boop.play()
			if event.is_action_pressed("jump"):
				match current_button.btn_name:
					"Play":
						$SFX/DingBig.play()
						Globals.menu_current = null
						await get_tree().create_timer(.9).timeout
						get_tree().change_scene_to_file("res://scenes/top/game_topdown.tscn")
					"Options":
						current_submenu = Sub.OPTIONS
						$SFX/DingSmall.play()
					"Credits":
						current_submenu = Sub.CREDITS
						$SFX/DingSmall.play()
		Sub.OPTIONS:
			if event.is_action_pressed("jump"):
				current_submenu = Sub.TITLE
		Sub.CREDITS:
			if event.is_action_pressed("up") and current_button.up:
				current_button = current_button.up
				$SFX/Boop.play()
			if event.is_action_pressed("down") and current_button.down:
				current_button = current_button.down
				$SFX/Boop.play()
			if event.is_action_pressed("left") and current_button.left:
				current_button = current_button.left
				$SFX/Boop.play()
			if event.is_action_pressed("right") and current_button.right:
				current_button = current_button.right
				$SFX/Boop.play()
			if event.is_action_pressed("jump"):
				match current_button.name:
					"Back":
						current_submenu = Sub.TITLE
						$SFX/DingSmall.play()
					"Filipe":
						OS.shell_open("https://the-bard-at-your-service.itch.io/")
						$SFX/DingSmall.play()
					"Lance":
						OS.shell_open("https://bit-lance.itch.io/")
						$SFX/DingSmall.play()
					"Lam":
						OS.shell_open("https://laffcat.itch.io/")
						$SFX/DingSmall.play()
						



func _ready(): Globals.menu_current = self






















#####
