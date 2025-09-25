extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_move_left_button_down() -> void:
	Input.action_press("move_left")

func _on_move_left_button_up() -> void:
	Input.action_release("move_left")


func _on_move_right_button_down() -> void:
	Input.action_press("move_right")

func _on_move_right_button_up() -> void:
	Input.action_release("move_right")


func _on_chage_button_down() -> void:
	Input.action_press("chage")

func _on_chage_button_up() -> void:
	Input.action_release("chage")


func _on_jump_button_down() -> void:
	Input.action_press("jump")

func _on_jump_button_up() -> void:
	Input.action_release("jump")


func _on_attck_button_down() -> void:
	Input.action_press("attack")

func _on_attck_button_up() -> void:
	Input.action_release("attack")
