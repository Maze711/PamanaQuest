extends Panel

@onready var dialogue_text = $Label
@onready var choices_container = null # Assign this if you add a VBoxContainer for choices

var dialogue_tree = {}
var typing_speed := 0.02 # Seconds per character

# Call this to start a dialogue. Pass the dialogue tree and the start node.
func start_dialogue(tree: Dictionary, start_node: String = "start"):
	dialogue_tree = tree
	show_node(start_node)
	show()

# Show a dialogue node with typewriter effect
func show_node(node_name: String) -> void:
	var node = dialogue_tree.get(node_name, null)
	if node == null:
		hide()
		return

	# Clear old choices if you have a choices container
	if choices_container:
		for child in choices_container.get_children():
			child.queue_free()

	await type_text(node.get("text", ""))

	# Add choices if you have a choices container
	if choices_container:
		if node.has("choices"):
			for choice in node["choices"]:
				var btn = Button.new()
				btn.text = choice["text"]
				btn.connect("pressed", Callable(self, "_on_choice_pressed").bind(choice["next"]))
				choices_container.add_child(btn)
		else:
			var btn = Button.new()
			btn.text = "Next"
			btn.connect("pressed", Callable(self, "_on_choice_pressed").bind("end"))
			choices_container.add_child(btn)

# Typewriter effect
func type_text(text: String) -> void:
	dialogue_text.text = ""
	for i in text.length():
		dialogue_text.text += text[i]
		await get_tree().create_timer(typing_speed).timeout

# Handle choice selection
func _on_choice_pressed(next_node: String):
	if next_node == "end":
		hide()
	else:
		show_node(next_node)
