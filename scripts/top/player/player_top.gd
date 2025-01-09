class_name PlayerTop
extends CharacterBody2D

const BULLET1 = preload("res://scenes/top/player/bullet_tank.tscn")
const MAX_SPEED = 160.0
const ACCEL = .8
const DECEL = .6
const TURNING = 5.0

var speed_current := 0.0
var vel_dir := Vector2.ZERO
var tween_shoot : Tween

var active := true

func pause(): active = false
func unpause(): active = true

func _ready():
	Globals.paused.connect(pause)
	Globals.unpaused.connect(unpause)
	Globals.player_current = self


func _process(delta: float) -> void:
	if active:
		$TankTop.rotation = global_position.direction_to(Globals.cursor.global_position).angle()
		if Input.is_action_just_pressed("atk1"): shoot()


func _physics_process(delta: float) -> void:
	
	if active:
		var direction := Input.get_vector("left", "right", "up", "down")
		if direction:
			speed_current = lerp(speed_current, MAX_SPEED, ACCEL * delta)
			vel_dir = lerp(vel_dir, direction, TURNING * delta)
		else:
			speed_current = lerp(speed_current, 0.0, DECEL * delta)
		
		velocity = vel_dir * speed_current
			
		move_and_slide()
		vel_dir = velocity.normalized()
		$SprTankBase.rotation = vel_dir.angle()


func shoot():
	if tween_shoot: tween_shoot.kill()
	tween_shoot = create_tween()
	$TankTop/SprTankBarrel.position.x = 8.5
	tween_shoot.tween_property($TankTop/SprTankBarrel, "position", Vector2(15.0, 0.0), .4)
	
	var new_bullet := BULLET1.instantiate()
	$"..".add_child(new_bullet)
	new_bullet.dir = global_position.direction_to($TankTop/BulletSpawn.global_position)
	new_bullet.global_position = $TankTop/BulletSpawn.global_position
















##### 
