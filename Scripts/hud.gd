extends CanvasLayer

@onready var score_label: Label = $Control/MarginContainer/HBoxContainer/ScoreLabel
@onready var level_label: Label = $Control/MarginContainer/HBoxContainer/LevelLabel


func _ready() -> void:
	var gm = get_node_or_null("/root/GameManager")
	if gm:
		gm.score_changed.connect(_on_score_changed)
		update_hud(gm.score, gm.current_level)


func _on_score_changed(new_score: int) -> void:
	var gm = get_node_or_null("/root/GameManager")
	if gm:
		update_hud(new_score, gm.current_level)


func update_hud(score: int, level: int) -> void:
	if score_label:
		score_label.text = "SCORE: %04d" % score
	if level_label:
		level_label.text = "LEVEL %d" % level
