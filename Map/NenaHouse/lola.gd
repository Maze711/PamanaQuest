extends CharacterBody2D

@onready var talk_hint = get_node("/root/world/CanvasLayer/TalkHint")
@onready var dialogue_box = get_node("/root/world/CanvasLayer/DialogueBox")

var player_in_range = false
var talking = false

func _ready():
	talk_hint.visible = false
	dialogue_box.visible = false

func _on_interaction_area_body_entered(body: Node2D) -> void:
	print("Entered area:", body.name)
	if body.name.to_lower() == "eloy":
		player_in_range = true
		talk_hint.visible = true

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.name.to_lower() == "eloy":
		player_in_range = false
		talk_hint.visible = false
		dialogue_box.visible = false
		talking = false

func _input(event):
	if player_in_range and event.is_action_pressed("interact"):
		print("Interact pressed! Talking:", talking)
		if not talking:
			dialogue_box.show()
			dialogue_box.start_dialogue()
			talk_hint.visible = false
			talking = true
