extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is EnemyTop: if !body.invuln:
		body.damage(5, global_position.distance_to(body.global_position), global_position.direction_to(body.global_position))
