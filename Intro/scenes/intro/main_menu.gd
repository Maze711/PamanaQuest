extends Control

# --- START button ---
func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Intro/scenes/intro/save_option.tscn")


# --- OPTIONS button ---
func _on_options_pressed() -> void:
	# Placeholder for Options menu (e.g. settings, audio, etc.)
	print("Options button pressed - add options menu later")

# --- QUIT button ---
func _on_quit_pressed() -> void:
	get_tree().quit()
