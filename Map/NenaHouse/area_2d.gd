extends Area2D

signal interact

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "Player":
		set_process_input(true)

func _input(event):
	if event.is_action_pressed("interact"):
		emit_signal("interact")
		set_process_input(false)


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.


func _on_interact() -> void:
	get_tree().change_scene_to_file("res://Tutorial/RiverSide.tscn")
