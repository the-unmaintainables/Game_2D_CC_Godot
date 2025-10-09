extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	# PlayFabがログインできていないなら画面を消す
	#if !GameManager.was_login:
		#self.visible = false
	# PlayFabにログインできたら画面を表示する
	SignalManager.connect("playfab_login", _on_playfab_login)
	
	pass # Replace with function body.
# PlayFabにログインできたら画面を表示する
func _on_playfab_login():
	self.visible = true


func _process(delta: float) -> void:
	# タイトルでPキーを押すとクリア画面へ飛べる。(デバッグ用)
	if Input.is_key_pressed(KEY_P):
		GameManager.load_clear_scene()

# スタートボタンが押されたらステージ1へ移動
func _on_start_button_pressed() -> void:
	SignalManager.stage_start.emit()
	GameManager.load_stage1_scene()
	
	# Web環境でのみオーディオコンテキストを再開
	if OS.has_feature("web"):
		GameManager._resume_web_audio()
	BGM.play()

# ランキングへ行く
func _on_ranking_button_pressed() -> void:
	GameManager.load_ranking_scene()

# デバッグ用にクリア画面へ
func _on_clear_button_pressed() -> void:
	#GameManager.load_clear_scene()
	get_tree().change_scene_to_file("res://ui/CreateAccount.tscn")
