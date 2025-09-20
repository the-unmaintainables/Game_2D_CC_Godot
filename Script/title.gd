extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# スタートボタンが押されたらステージ1へ移動
func _on_start_button_pressed() -> void:
	SignalManager.stage_start.emit()
	GameManager.load_stage1_scene()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
