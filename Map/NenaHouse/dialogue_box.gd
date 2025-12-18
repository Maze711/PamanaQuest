extends Control

@onready var dialogue_text = $DialogueText
@onready var choices_container = $Choices   # VBoxContainer

var dialogue_tree = {
	"start": {
		"text": "Eloy, puro ka na lang selpon! Kuhain mo nga 
		yung paso sa kabilang kwarto. Ingatan mo iyon, 
		dahil minana pa natin sa ating mga ninuno.",
		"choices": [
			{"text": "Sige po, Lola.", "next": "good_reply"},
			{"text": "Ay, nakakainip naman yan, Lola.", "next": "bad_reply"}
		]
	},
	"good_reply": {
		"text": "Mabuti naman at nakikinig ka, Eloy. Alam mo ba, 
		ang paso na yan ay may ukit na sinaunang Baybayin. 
		Isa itong pamana ng ating lahi.",
		"choices": [
			{"text": "Wow, ang galing naman!", "next": "end"}
		]
	},
	"bad_reply": {
		"text": "Hay nako, Eloy... darating din ang araw na 
		maiintindihan mo kung gaano kahalaga ang ating pinagmulan.",
		"choices": [
			{"text": "Opo, Lola, sige na po...", "next": "end"}
		]
	},
}



var typing_speed := 0.0001  # Seconds per character

# Start a dialogue
func start_dialogue(start_node: String = "start"):
	show_node(start_node)
	show()

# Display a dialogue node with typewriter effect
func show_node(node_name: String) -> void:
	var node = dialogue_tree[node_name]

	# Clear old choices
	for child in choices_container.get_children():
		child.queue_free()

	# Typewriter effect
	await type_text(node["text"])

	# Add new choices
	if node.has("choices"):
		for choice in node["choices"]:
			var btn = Button.new()
			btn.text = choice["text"]
			btn.add_theme_font_size_override("font_size", 8.5)
			btn.connect("pressed", Callable(self, "_on_choice_pressed").bind(choice["next"]))
			choices_container.add_child(btn)
	else:
		# If no choices, add a default "Next" button
		var btn = Button.new()
		btn.text = "Next"
		btn.add_theme_font_size_override("font_size", 8.5)
		btn.connect("pressed", Callable(self, "_on_choice_pressed").bind("end"))
		choices_container.add_child(btn)

# Typewriter effect function
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

func _on_dialogue_finished():
	$CanvasLayer/ArrowHint.visible = true
