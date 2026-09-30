extends Control

@onready var play_button: Button = $MarginContainer/VBoxContainer/PlayButton
@onready var quit_button: Button = $MarginContainer/VBoxContainer/QuitButton


func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if play_button:
		play_button.pressed.connect(_on_play_pressed)
	if quit_button:
		quit_button.pressed.connect(_on_quit_pressed)


func _on_play_pressed() -> void:
	var gm = get_node_or_null("/root/GameManager")
	if gm:
		gm.start_game()
	else:
		get_tree().change_scene_to_file("res://Scenes/level_1.tscn")


func _on_quit_pressed() -> void:
	var gm = get_node_or_null("/root/GameManager")
	if gm:
		gm.quit_game()
	else:
		get_tree().quit()
