class_name EnemyTop
extends CharacterBody2D


const SPEED = 100.0
var vel_add := Vector2.ZERO
var active := true
var invuln := false
var health := 6

func pause(): active = false
func unpause(): active = true

func _ready():
	Globals.paused.connect(pause)
	Globals.unpaused.connect(unpause)
	
func _physics_process(delta: float) -> void:
	if active:
		var dir = global_position.direction_to(Globals.player_current.global_position)
		rotation = dir.angle()
		velocity = dir * SPEED + vel_add
		move_and_slide()
		if vel_add:
			vel_add.limit_length( max(0.0, vel_add.length() - 200.0 * delta) )

func damage(dmg : int, dist : float, dir : Vector2):
	health -= dmg
	vel_add = dir * (150.0 - dist) # TODO: dist almost certainly needs a multiplier here
