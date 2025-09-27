extends Node2D

# 基準となる画面サイズ（デザイン時の解像度）
const BASE_WIDTH = 1920
const BASE_HEIGHT = 1080

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	
	# 画面サイズが変更されたときに_on_viewport_size_changed関数を呼び出す
	#get_viewport().size_changed.connect(_on_viewport_size_changed)
	#_on_viewport_size_changed() # 初期サイズに合わせて一度実行

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
	
	# Web環境でのみオーディオコンテキストを再開
	if OS.has_feature("web"):
		GameManager._resume_web_audio()
	BGM.play()

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_viewport_size_changed():
	# 現在のビューポートのサイズを取得
	var current_size = get_viewport().size
	
	# 幅と高さの比率を計算
	var scale_x = current_size.x / float(BASE_WIDTH)
	var scale_y = current_size.y / float(BASE_HEIGHT)
	
	# どちらか小さい方の比率をUI全体のスケールとして使用
	var scale_factor = min(scale_x, scale_y)
	
	# CanvasLayer全体のスケールを更新
	set_scale(Vector2(scale_factor, scale_factor))
	print(scale_x)
	print(scale_y)
