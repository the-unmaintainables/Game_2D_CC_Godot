extends Node2D

var error = false
const LEADERBOARD_NAME = "TestRanking"
const Playfab = preload("res://addons/godot-playfab/PlayFab.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayFabManager.client.connect("logged_in", Callable(self, "_on_login_success"))
	PlayFabManager.client.connect("api_error", Callable(self, "_on_api_error"))
	PlayFabManager.client.connect("server_error", Callable(self, "_on_server_error"))
	
	PlayFabManager.client.login_anonymous()
	pass # Replace with function body.

func _on_login_success(result):
	print("ログイン成功")
	pass

func _on_api_error(result):
	error = true
	print("api_error")
	# 画面ポーズの解除
	get_tree().paused = true

func _on_server_error(result):
	error = true
	print("server_error")
	# 画面ポーズの解除
	get_tree().paused = true


func _on_exit_button_pressed() -> void:
	GameManager.load_title_scene()
	pass # Replace with function body.


func _on_submit_button_pressed() -> void:
	# スコアが記録されるまでは画面をポーズ
	# ポーズ状態を切り替える
	get_tree().paused = false
	
	if !error:
		print($PauseOverlay/PlayerName.text)
		change_name($PauseOverlay/PlayerName.text)
		print("名前を変更成功")
		submit_score(GameManager.stage_score)
	
	if !error:
		print("エラーなしで登録できました")
	pass # Replace with function body.

func change_name(name):
	var body = {
		"DisplayName": name
	}
	PlayFabManager.client.post_dict_auth(body,"/Client/UpdateUserTitleDisplayName",Playfab.AUTH_TYPE.SESSION_TICKET)

func sucess_change_name(result):
	submit_score(100)

func submit_score(new_score: int):
	var body = {
		 "Statistics": [
			{"StatisticName": LEADERBOARD_NAME, "Value": new_score}
		]
	}
	
	PlayFabManager.client.post_dict_auth(body,"/Client/UpdatePlayerStatistics",Playfab.AUTH_TYPE.SESSION_TICKET,self.sucess_submit_socre)

func sucess_submit_socre(result):
	print("スコアを記録できました")
	# 画面ポーズの解除
	get_tree().paused = true
