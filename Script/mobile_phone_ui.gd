extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# スマホでないならUIを消す
	if GameManager.mouse_ui:
		print("マウスUI")
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_move_right_pressed() -> void:
	Input.action_press("move_right")

func _on_move_right_released() -> void:
	Input.action_release("move_right")


func _on_chage_pressed() -> void:
	Input.action_press("chage")

func _on_chage_released() -> void:
	Input.action_release("chage")


func _on_attack_pressed() -> void:
	Input.action_press("attack")


func _on_attack_released() -> void:
	Input.action_release("attack")


func _on_move_left_pressed() -> void:
	Input.action_press("move_left")

func _on_move_left_released() -> void:
	Input.action_release("move_left")


func _on_jump_pressed() -> void:
	Input.action_press("jump")

func _on_jump_released() -> void:
	Input.action_release("jump")


func _on_pause_pressed() -> void:
	Input.action_press("pause")

func _on_pause_released() -> void:
	Input.action_release("pause")
