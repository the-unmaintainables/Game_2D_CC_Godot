extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# スタートボタンが押されたらステージ1へ移動
func _on_button_pressed() -> void:
	GameManager.load_stage1_scene()
