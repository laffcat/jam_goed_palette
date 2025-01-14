extends CanvasLayer

@onready var health_bar: ProgressBar = $Container/MarginContainer/HBoxContainer/HPBox/HP
@onready var hp_label: Label = $Container/MarginContainer/HBoxContainer/HPBox/Label

@onready var rad_bar: ProgressBar = $Container/MarginContainer/HBoxContainer/InfBox/Radiation
@onready var rad_label: Label = $Container/MarginContainer/HBoxContainer/InfBox/Label



func shake_node(subj: Node, bounces: int, distance, col: Color) -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	var original_position: Vector2 = subj.position
	subj.modulate = col
	for e in bounces: #alternative set_loops(bounces)
		tween.tween_property(subj, "position", Vector2(subj.position.x + distance, subj.position.y), 0.1)
		distance *= -0.8
	tween.tween_property(subj, "position", original_position, 0.1)
	await tween.finished 
	subj.modulate = Color.WHITE


func _on_character_just_got_grabbed() -> void:
	pass
	#shake_node(bal, 7, 40.0, Color.DARK_RED)


func _on_side_character_update_ui(hp: float, rad: float) -> void:
	health_bar.value = hp
	rad_bar.value = rad
