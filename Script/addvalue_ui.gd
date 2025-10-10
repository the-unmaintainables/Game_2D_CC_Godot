extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Titleボタンが押されたらランキングへ
func _on_exit_button_pressed() -> void:
	GameManager.load_ranking_scene()

# 記録を登録するボタンが押されたら
func _on_submit_button_pressed() -> void:
	
	# 個人アカウントではない場合、ログイン画面を出す
	if PlayFabManager.client_config.master_player_account_id == "DE66A5BB494E1E5A":
		get_tree().change_scene_to_file("res://ui/loginAccount_clear.tscn")
		return
	else:
		get_tree().change_scene_to_file("res://ui/SNS.tscn")
