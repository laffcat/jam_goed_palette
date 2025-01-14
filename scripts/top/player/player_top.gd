class_name PlayerTop
extends CharacterBody2D

const BULLET1 = preload("res://scenes/top/player/bullet_tank.tscn")
const BULLET2 = preload("res://scenes/top/player/beam_tank.tscn")

const MAX_SPEED = 160.0
const ACCEL = .8
const DECEL = .6
const TURNING = 5.0

var speed_current := 0.0
var vel_dir := Vector2.ZERO
var tween_shoot : Tween
var can_shoot := true
var can_beam := true

var hp := 5
var invuln := true

var active := true

@onready var hud_hp_pts : Array[Sprite2D] = [
	$Camera2D/HUD/Hp1	,
	$Camera2D/HUD/Hp2	,
	$Camera2D/HUD/Hp3	,
	$Camera2D/HUD/Hp4	,
	$Camera2D/HUD/Hp5	]

@onready var sprites : Array[Sprite2D] = [
	$SprTankBase			, 
	$TankTop/SprTankBarrel	, 
	$TankTop/SprTankHead	]
	
func sprite(frame : int): for each in sprites: each.frame = frame


func pause(): 
	active = false
	Globals.menu_current = $Camera2D/MenuPause
func unpause(): 
	active = true
	Globals.menu_current = null

func _ready():
	Globals.paused.connect(pause)
	Globals.unpaused.connect(unpause)
	Globals.player = self
	await get_tree().create_timer(.1).timeout
	invuln = false


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_die"):
		hp = 0
		hurt()
	if active and hp > 0:
		$TankTop.rotation = global_position.direction_to(Globals.cursor.global_position).angle()
		if Input.is_action_pressed("atk1"): shoot()
		if Input.is_action_pressed("atk2"): shoot_beam()


func _physics_process(delta: float) -> void:
	
	if active:
		var direction := Input.get_vector("left", "right", "up", "down")
		if direction and hp > 0:
			speed_current = lerp(speed_current, MAX_SPEED, ACCEL * delta)
			vel_dir = lerp(vel_dir, direction, TURNING * delta)
		else:
			speed_current = lerp(speed_current, 0.0, DECEL * delta)
		
		velocity = vel_dir * speed_current
			
		move_and_slide()
		vel_dir = velocity.normalized()
		$SprTankBase.rotation = vel_dir.angle()


func shoot():
	if !can_shoot or hp <= 0: return 
	can_shoot = false
	$Camera2D/HUD/MouseIconM1.modulate = Color.BLACK
	var tween_cooldown := create_tween()
	$Camera2D/HUD/MouseButton1.material.set_shader_parameter("progress", 0.0)
	tween_cooldown.tween_property($Camera2D/HUD/MouseButton1, "material:shader_parameter/progress", 1.0, .6)
	$SFX/ShootBasic.play()
	
	if tween_shoot: tween_shoot.kill()
	tween_shoot = create_tween()
	$TankTop/SprTankBarrel.position.x = 8.5
	tween_shoot.tween_property($TankTop/SprTankBarrel, "position", Vector2(15.0, 0.0), .4)
	
	var new_bullet := BULLET1.instantiate()
	Globals.main.add_child(new_bullet)
	new_bullet.dir = global_position.direction_to($TankTop/BulletSpawn.global_position)
	new_bullet.global_position = $TankTop/BulletSpawn.global_position
	
	await get_tree().create_timer(.6).timeout
	can_shoot = true
	$Camera2D/HUD/MouseIconM1.modulate = Color.WHITE
	
func shoot_beam():
	if !can_shoot or !can_beam or hp <= 0: return 
	can_shoot = false
	can_beam = false
	$Camera2D/HUD/MouseIconM2.modulate = Color.BLACK
	var tween_cooldown_beam := create_tween()
	$Camera2D/HUD/MouseButton2.material.set_shader_parameter("progress", 0.0)
	tween_cooldown_beam.tween_property($Camera2D/HUD/MouseButton2, "material:shader_parameter/progress", 1.0, 9.0)
	$SFX/ShootBeamCharge.play(.8)
	
	if tween_shoot: tween_shoot.kill()
	tween_shoot = create_tween()
	tween_shoot.tween_property($TankTop/SprTankBarrel, "position", Vector2(12.0, 0.0), .5)
	await tween_shoot.finished
	$SFX/ShootBeamCharge.stop()
	$SFX/ShootBeamFire.play()
	
	tween_shoot = create_tween()
	$TankTop/SprTankBarrel.position.x = 5.5
	tween_shoot.tween_property($TankTop/SprTankBarrel, "position", Vector2(15.0, 0.0), .9)
	
	
	var new_bullet := BULLET2.instantiate()
	Globals.main.add_child(new_bullet)
	new_bullet.dir = global_position.direction_to($TankTop/BulletSpawn.global_position)
	new_bullet.global_position = $TankTop/BulletSpawn.global_position
	
	await get_tree().create_timer(1.1).timeout
	can_shoot = true
	
	await tween_cooldown_beam.finished
	$Camera2D/HUD/MouseIconM2.modulate = Color.WHITE
	can_beam = true
	
	

func hurt():
	if invuln: return
	invuln = true
	$SFX/Hurt.play()
	sprite(1)
	hp -= 1
	update_hp_meter()
	await get_tree().create_timer(1.2).timeout
	if hp > 0:
		invuln = false
		sprite(0)
	else:
		if OS.get_name() == "HTML5":
			$SFX/musicPLACEHOLDER.stop()
		else:
			$SFX/musicPLACEHOLDER.pitch_scale = .8
			$SFX/musicPLACEHOLDER.play($SFX/musicPLACEHOLDER.get_playback_position())
		sprite(2)
		await get_tree().create_timer(.6).timeout
		Globals.menu_current = $Camera2D/MenuGameOver

func update_hp_meter():
	for each in 6:
		if each > hp:
			hud_hp_pts[each - 1].frame = 1

func _on_area_hurt_body_entered(body: Node2D) -> void:
	if body is EnemyTop and body.global_position.distance_to(global_position) < 20: 
		hurt()












##### 
