extends Control

@onready var text_label = $RichTextLabel
@onready var image = $TextureRect
@onready var bgm = $AudioStreamPlayer2D  
@onready var title_logo = $TitleScreen 
@onready var tap_label = $TapLabel

# Slides
var slides = [
	{"image": "res://Intro/images/str_pan/spr_story_1.png", "text": "Matagal na, sa kasalukuyang\npanahon may isang binatilyo na\nang pangalan ay\nELOY CARDOZO"},
	{"image": "res://Intro/images/str_pan/spr_story_2.png", "text": "Matalino siya, ngunit tamad.\nLulong sa mga laro sa cellphone,\nat walang tigil na pag-scroll sa\nsocial media."},
	{"image": "res://Intro/images/str_pan/spr_story_3.png", "text": "Ayaw niya sa paaralan, lalo na sa klase ng kasaysayan\n'Matagal na iyon, bakit ko pa\npapakialaman?'\nmadalas nyang sabihin"},
	{"image": "res://Intro/images/str_pan/spr_story_4.png", "text": "Ngunit may isang taong naniniwala pa rin sa kapangyarihan ng\nnakaraan siya ay ang kanyang\nLOLA"},
	{"image": "res://Intro/images/str_pan/spr_story_4.png", "text": "Isang mabait at mapagmahal na\nmatanda, malalim ang ugat sa\ntradisyong pilipino"},
	{"image": "res://Intro/images/str_pan/spr_story_5.png", "text": "Isang araw, inalok siya ng\nisang lumang pamana ng pamilya\nisang banga, na may nakaukit na\nsinaunang simbolong Baybayin"},
	{"image": "res://Intro/images/str_pan/spr_story_5.png", "text": "'Ang bangang ito ay may dalang\nmga kuwentong mas matanda pa\nsa iyo...'\nmahina niyang bulong"},
	{"image": "res://Intro/images/str_pan/spr_story_6.png", "text": "Ngunit si Eloy ay nagpabuntong-\nhininga lang,ipinailing ang\nkanyang mga mata at naglakad\npalayo"},
	{"image": "res://Intro/images/str_pan/spr_story_7.png", "text": "Kinagabihan, habang naglalaro sya\nsa sala natisod niya ang banga,\nat biglang..."},
	{"image": "res://Intro/images/str_pan/spr_story_8.png", "text": "Nabasag ang banga\nnagkalat ang mga piraso sa\nsahig..."},
	{"image": "res://Intro/images/str_pan/spr_story_9.png", "text": "Isang pagsabog ng gintong liwanag ang kumawala.\nUmiikot ito sa buong silid,\nnabitawan niya ang cellphone,\nat nagdilim ang lahat."},
	{"image": "res://Intro/images/str_pan/spr_story_10.png", "text": ""}
]

var skip_requested: bool = false  # 🔑 skip flag

func _ready():
	show_title()

# --- Handle Skip Input ---
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event is InputEventScreenTouch:
		skip_requested = true

# --- Show title before cutscene ---
func show_title() -> void:
	title_logo.visible = true
	title_logo.modulate.a = 1.0

	await get_tree().create_timer(2.0).timeout
	title_logo.visible = false
	run_cutscene()

# --- Run slides ---
func run_cutscene() -> void:
	for i in range(slides.size()):
		if skip_requested:   # 🔑 immediately break
			break
		var slide = slides[i]
		
		if i == 0 and bgm.stream and not bgm.playing:
			bgm.play()
		
		await show_slide(slide["image"], slide["text"], i)
	
	if bgm.playing:
		bgm.stop()
	
	await show_end_logo()
	print("Cutscene finished!")

func show_slide(img_path: String, narration: String, index: int) -> void:
	if skip_requested:
		return  # nothing to show if already skipped before this slide

	image.texture = load(img_path)
	text_label.text = ""

	if index == 0:
		image.modulate.a = 1.0
	else:
		image.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(image, "modulate:a", 1.0, 1.5)
		await tween.finished

	for i in narration.length():
		if skip_requested:
			text_label.text = ""       # 🔑 instantly clear text
			image.modulate.a = 0.0     # 🔑 instantly hide image
			return
		text_label.text = narration.substr(0, i + 1)
		await get_tree().create_timer(0.06).timeout

	if skip_requested:
		text_label.text = ""           # 🔑 also clear text here
		image.modulate.a = 0.0
		return

	await get_tree().create_timer(0.9).timeout

	var tween = create_tween()
	tween.tween_property(image, "modulate:a", 0.0, 1.0)
	await tween.finished
	text_label.text = ""               # 🔑 clear narration at end of slide

# --- Show logo after cutscene ---
func show_end_logo() -> void:
	title_logo.visible = true
	title_logo.modulate.a = 0.0
	tap_label.visible = false

	var tween = create_tween()
	tween.tween_property(title_logo, "modulate:a", 1.0, 2.0)
	await tween.finished

	tap_label.visible = true
	blink_tap_label()
	await wait_for_input()

	get_tree().change_scene_to_file("res://Intro/scenes/intro/main_menu.tscn")

func blink_tap_label() -> void:
	var tween = create_tween().set_loops()
	tween.tween_property(tap_label, "modulate:a", 0.0, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(tap_label, "modulate:a", 1.0, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func wait_for_input() -> void:
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed("ui_accept") \
		or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			break
