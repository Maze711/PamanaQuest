extends CharacterBody2D

const speed = 100
var current_dir = "none"
var ui_direction := Vector2.ZERO

func _ready() -> void:
	$eloy.play("front_idle")

func _physics_process(delta: float) -> void:
	player_movement(delta)

func player_movement(delta): 
	var direction = Vector2.ZERO

	# Arrow keys and WASD
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("move_up"):
		direction.y -= 1

	# Button keys
	direction += ui_direction

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * speed

		# Animation and direction logic
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				current_dir = "right"
			else:
				current_dir = "left"
			play_anim(1)
		else:
			if direction.y > 0:
				current_dir = "down"
			else:
				current_dir = "up"
			play_anim(1)
	else:
		velocity = Vector2.ZERO
		play_anim(0)
	
	move_and_slide()
	
func play_anim(movement):
	var dir = current_dir
	var anim = $eloy
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_right")
		elif movement == 0:
			anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("walk_right")
		elif movement == 0:
			anim.play("side_idle")
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_front")
		elif movement == 0:
			anim.play("front_idle")
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_back")
		elif movement == 0:
			anim.play("back_idle")

# UI BUTTON SIGNALS
func _on_btn_up_button_down() -> void: ui_direction.y = -1
func _on_btn_up_button_up() -> void: if ui_direction.y == -1: ui_direction.y = 0

func _on_btn_left_button_down() -> void: ui_direction.x = -1
func _on_btn_left_button_up() -> void: if ui_direction.x == -1: ui_direction.x = 0

func _on_btn_right_button_down() -> void: ui_direction.x = 1
func _on_btn_right_button_up() -> void: if ui_direction.x == 1: ui_direction.x = 0

func _on_btn_down_button_down() -> void: ui_direction.y = 1
func _on_btn_down_button_up() -> void: if ui_direction.y == 1: ui_direction.y = 0

func _on_button_3_button_down():
	print("Button3 down")
	Input.action_press("interact")

func _on_button_3_button_up():
	print("Button3 up")
	Input.action_release("interact")
