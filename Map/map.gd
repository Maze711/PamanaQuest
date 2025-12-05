extends Node2D

func _input(event):
	if event.is_action_pressed("ui_accept"):
		test_transition()

func test_transition():
	Transition.fade_out()
	await Transition.fade_out_finished
	Transition.fade_in()
