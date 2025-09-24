extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	# 3秒後に関数を呼び出すタイマー
	get_tree().create_timer(3).timeout.connect(on_timer_timeout)

func on_timer_timeout():
	SignalManager.stage_start.emit()
	GameManager.load_stage1_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# スタートボタンが押されたらステージ1へ移動
func _on_start_button_pressed() -> void:
	SignalManager.stage_start.emit()
	GameManager.load_stage1_scene()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
