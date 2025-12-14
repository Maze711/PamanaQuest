extends Control

@onready var dialog_box = $DialogContainer
@onready var dialog_label = $DialogContainer/Label

var dialog = [
	"Welcome to Pamana Quest!",
	"You must find the lost treasure.",
	"Talk to the villagers for clues.",
	"Good luck on your journey!"
]
var dialog_index = 0

func _ready():
	show_dialog()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		dialog_index += 1
		if dialog_index < dialog.size():
			show_dialog()
		else:
			dialog_box.hide()  # or queue_free() to remove

func show_dialog():
	dialog_label.text = dialog[dialog_index]
