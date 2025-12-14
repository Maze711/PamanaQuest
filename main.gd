extends Node2D

var cutscene_scene := preload("res://Intro/scenes/intro/cutscene.tscn")
var menu_scene := preload("res://Intro/scenes/intro/main_menu.tscn")
var save_scene := preload("res://Intro/scenes/intro/save_option.tscn")
var map_scene  := preload("res://Map/Map.tscn")

var current_scene: Node
var selected_slot := 1

func _ready():
	show_cutscene()

func show_cutscene():
	current_scene = cutscene_scene.instantiate()
	add_child(current_scene)
	current_scene.connect("cutscene_finished", _on_cutscene_finished)

func _on_cutscene_finished():
	show_menu()

func show_menu():
	current_scene = menu_scene.instantiate()
	add_child(current_scene)
	current_scene.connect("start_game", _on_start_game)

func _on_start_game():
	_show_save_menu()

func _show_save_menu():
	current_scene.queue_free()
	current_scene = save_scene.instantiate()
	add_child(current_scene)
	await get_tree().create_timer(0.5).timeout
	_on_save_selected(1)

func _on_save_selected(slot: int):
	selected_slot = slot
	_load_map()

func _load_map():
	current_scene.queue_free()
	current_scene = map_scene.instantiate()
	add_child(current_scene)
