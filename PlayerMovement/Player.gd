extends CharacterBody2D

@export var speed: float = 200.0

@onready var info_label: Label = $CanvasLayer/PanelContainer/Label
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var ui_direction := Vector2.ZERO
var last_non_zero_direction := Vector2.DOWN
var current_anim := ""
var is_moving := false

func _ready():
	update_idle_anim()

func play_anim(name: String):
	if current_anim == name:
		return  # avoid restarting animation every frame
	current_anim = name
	animated_sprite.play(name)

func update_idle_anim():
	# Play idle based on last direction
	if abs(last_non_zero_direction.x) > abs(last_non_zero_direction.y):
		if last_non_zero_direction.x > 0:
			play_anim("idle_right")
		else:
			play_anim("idle_left")
	else:
		if last_non_zero_direction.y > 0:
			play_anim("idle_front")
		else:
			play_anim("idle_back")

func _physics_process(_delta: float) -> void:
	var direction = Vector2.ZERO

	# Keyboard input
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1

	# UI buttons
	direction += ui_direction

	if direction != Vector2.ZERO:
		last_non_zero_direction = direction
		direction = direction.normalized()
		velocity = direction * speed
		move_and_slide()
		is_moving = true

		# Animation selection based on dominant axis
		if abs(last_non_zero_direction.x) > abs(last_non_zero_direction.y):
			if last_non_zero_direction.x > 0:
				play_anim("walk_right")
			else:
				play_anim("walk_left")
		else:
			if last_non_zero_direction.y > 0:
				play_anim("walk_front")
			else:
				play_anim("walk_back")
	else:
		# Idle
		velocity = Vector2.ZERO
		move_and_slide()
		is_moving = false
		update_idle_anim()

	info_label.text = "Move with WASD or Buttons\nPos: (%.1f, %.1f)" % [global_position.x, global_position.y]

# UI BUTTON SIGNALS
func _on_btn_up_button_down() -> void: ui_direction.y = -1
func _on_btn_up_button_up() -> void: if ui_direction.y == -1: ui_direction.y = 0

func _on_btn_left_button_down() -> void: ui_direction.x = -1
func _on_btn_left_button_up() -> void: if ui_direction.x == -1: ui_direction.x = 0

func _on_btn_right_button_down() -> void: ui_direction.x = 1
func _on_btn_right_button_up() -> void: if ui_direction.x == 1: ui_direction.x = 0

func _on_btn_down_button_down() -> void: ui_direction.y = 1
func _on_btn_down_button_up() -> void: if ui_direction.y == 1: ui_direction.y = 0
