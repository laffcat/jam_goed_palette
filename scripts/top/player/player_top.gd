class_name PlayerTop
extends CharacterBody2D


const MAX_SPEED = 200.0
const ACCEL = .5
const DECEL = .3

var speed_current := 0.0
var vel_dir := Vector2.ZERO

func _ready():
	Globals.player_current = self


func _process(delta: float) -> void:
	$TankTop.rotation = global_position.direction_to(Globals.cursor.global_position).angle()


func _physics_process(delta: float) -> void:
	
	var direction := Input.get_vector("left", "right", "up", "down")
	if direction:
		speed_current = lerp(speed_current, MAX_SPEED, ACCEL * delta)
		vel_dir = lerp(vel_dir, direction, 5.0 * delta)
	else:
		speed_current = lerp(speed_current, 0.0, DECEL * delta)
	
	velocity = vel_dir * speed_current
		
	move_and_slide()
	vel_dir = velocity.normalized()
	$SprTankBase.rotation = vel_dir.angle()
