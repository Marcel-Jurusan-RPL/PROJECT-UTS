extends Node

var score: int = 0
var best_score: int = 0
var current_level: int = 1

const TOTAL_LEVELS: int = 3

signal score_changed(new_score: int)


func _ready() -> void:
	load_best_score()


func add_score(amount: int) -> void:
	score += amount
	if score > best_score:
		best_score = score
		save_best_score()
	score_changed.emit(score)


func reset_score() -> void:
	score = 0
	score_changed.emit(score)


func start_game() -> void:
	reset_score()
	current_level = 1
	go_to_level(1)


func next_level() -> void:
	current_level += 1
	if current_level > TOTAL_LEVELS:
		go_to_final_result()
	else:
		go_to_level(current_level)


func go_to_level(level_num: int) -> void:
	current_level = level_num
	var scene_path := "res://Scenes/level_" + str(level_num) + ".tscn"
	get_tree().change_scene_to_file(scene_path)


func go_to_main_menu() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func go_to_game_over() -> void:
	if score > best_score:
		best_score = score
		save_best_score()
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")


func go_to_final_result() -> void:
	if score > best_score:
		best_score = score
		save_best_score()
	get_tree().change_scene_to_file("res://Scenes/final_result.tscn")


func quit_game() -> void:
	get_tree().quit()


func load_best_score() -> void:
	if FileAccess.file_exists("user://best_score.save"):
		var file := FileAccess.open("user://best_score.save", FileAccess.READ)
		if file:
			best_score = file.get_32()


func save_best_score() -> void:
	var file := FileAccess.open("user://best_score.save", FileAccess.WRITE)
	if file:
		file.store_32(best_score)
