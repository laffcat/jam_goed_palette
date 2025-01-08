class_name EnemyTop
extends CharacterBody2D


const SPEED = 100.0


func _physics_process(delta: float) -> void:
	var dir = global_position.direction_to(Globals.player_current.global_position)
	rotation = dir.angle()
	velocity = dir * SPEED
	move_and_slide()
