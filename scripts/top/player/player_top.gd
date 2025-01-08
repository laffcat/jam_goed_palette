class_name PlayerTop
extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0


func _ready():
	Globals.player_top = self


func _physics_process(delta: float) -> void:
	
	var direction := Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = velocity.normalized() * ( velocity.length() - SPEED * .5 * delta )

	move_and_slide()
