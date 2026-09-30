extends Control

@onready var score_label: Label = $MarginContainer/VBoxContainer/ScoreLabel
@onready var best_score_label: Label = $MarginContainer/VBoxContainer/BestScoreLabel
@onready var restart_button: Button = $MarginContainer/VBoxContainer/RestartButton
@onready var main_menu_button: Button = $MarginContainer/VBoxContainer/MainMenuButton
@onready var quit_button: Button = $MarginContainer/VBoxContainer/QuitButton


func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var gm = get_node_or_null("/root/GameManager")
	if gm:
		if score_label:
			score_label.text = "SCORE: %04d" % gm.score
		if best_score_label:
			best_score_label.text = "BEST SCORE: %04d" % gm.best_score

	if restart_button:
		restart_button.pressed.connect(_on_restart_pressed)
	if main_menu_button:
		main_menu_button.pressed.connect(_on_main_menu_pressed)
	if quit_button:
		# QUIT on Game Over RETURNS to Main Menu as per explicit requirements!
		quit_button.pressed.connect(_on_main_menu_pressed)


func _on_restart_pressed() -> void:
	var gm = get_node_or_null("/root/GameManager")
	if gm:
		gm.start_game()
	else:
		get_tree().change_scene_to_file("res://Scenes/level_1.tscn")


func _on_main_menu_pressed() -> void:
	var gm = get_node_or_null("/root/GameManager")
	if gm:
		gm.go_to_main_menu()
	else:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
