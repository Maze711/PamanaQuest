extends Control

signal start_game

func _on_start_game_pressed() -> void:
	emit_signal("start_game")

func _on_options_pressed() -> void:
	print("Options button pressed")

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Intro/scenes/intro/main_menu.tscn")


func _on_save_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Map/NenaHouse/whole_world.tscn")
