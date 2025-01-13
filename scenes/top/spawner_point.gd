extends Node2D

const ROBIT = preload("res://scenes/top/enemy_top/robit.tscn")
const SPAWN_DELAY := 1.2

var spawn_delay_mult := 1.0
var spawning := true
var active := true
var clock := 0.0

func pause(): active = false
func unpause(): active = true


func _ready():
	Globals.paused.connect(pause)
	Globals.unpaused.connect(unpause)


func _process(delta: float) -> void:
	if active:
		clock -= delta
		if clock <= 0:
			spawn()
			clock += SPAWN_DELAY * spawn_delay_mult


func spawn():
	$"..".rotate(deg_to_rad(randi_range(30, 100)))
	var new_spawn : EnemyTop = ROBIT.instantiate()
	$"../../../../EnemyRoot".add_child(new_spawn)
	new_spawn.global_position = global_position
