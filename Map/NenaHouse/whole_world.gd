extends Node2D

func _ready():
	var vase = get_node("VaseArea")
	vase.connect("interact", Callable(self, "_on_vase_interact"))

func _on_vase_interact():
	get_tree().change_scene_to_file("res://Map/Tutorial/RiverSide.tscn")
