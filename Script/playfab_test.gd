extends Node

const Playfab = preload("res://addons/godot-playfab/PlayFab.gd")
const  LEADERBOARD_NAME = "TestRanking"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Playfabテスト")
	PlayFabManager.client.connect("logged_in", Callable(self, "_on_login_success"))
	PlayFabManager.client.connect("api_error", Callable(self, "_on_login_error"))
	PlayFabManager.client.connect("server_error", Callable(self, "_on_server_error"))
	PlayFabManager.client.login_anonymous()
	#add_child(playfab)
	#playfab.login_anonymous()
	pass # Replace with function body.

func _on_login_success(result: LoginResult):
	print("Login")
	print(result)
	
	#submit_score(2000, result.SessionTicket)
	fetch_leaderboard()

func submit_score(new_score: int, session_ticket: String):
	var body = {
		 "Statistics": [
			{"StatisticName": LEADERBOARD_NAME, "Value": new_score}
		]
	}
	
	PlayFabManager.client.post_dict_auth(body,"/Client/UpdatePlayerStatistics",Playfab.AUTH_TYPE.SESSION_TICKET, Callable(self, "input_score"))
	
	## 送信先のURL（PlayFabのAPI）
	#var url = "https://%s.playfabapi.com/Client/UpdatePlayerStatistics" % PlayFabManager.title_id
	## ヘッダー（手紙の封筒にあたる部分）
	#var headers = [
		#"Content-Type: application/json",          # 「中身はJSONですよ」と伝える
		#"X-Authentication: %s" % session_ticket    # 会員証を一緒に送る
	#]
	#var body = {
		 #"Statistics": [
			#{"StatisticName": LEADERBOARD_NAME, "Value": new_score}
		#]
	#}
	#
	## HTTPRequest ノードを使って送信
	#$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(body))


func fetch_leaderboard():
	var statistic_name = LEADERBOARD_NAME  # PlayFab側で設定した統計名
	var max_results = 10
	var body = {
		"StatisticName": statistic_name, "StartPosition": 0, "MaxResultsCount": max_results
	}
	
	PlayFabManager.client.post_dict_auth(body,"/Client/GetLeaderboard", Playfab.AUTH_TYPE.SESSION_TICKET, Callable(self, "_on_PlayFab_leaderboard_success"))
	

func _on_PlayFab_leaderboard_success(result):
	print("ランキング")
	print(result)
	var entries = result["data"]["Leaderboard"]
	for entry in entries:
		var name = entry["PlayFabId"]
		var score = entry["StatValue"]
		var rank = entry["Position"]
		print("%d位: %s - %d点" % [rank + 1, name, score])

func input_score(result):
	print("値の追加")

func _on_login_error(error):
	print("ログイン失敗")
	print(error)
	print(error.error)

func _on_server_error(error):
	print("サーバーエラー")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
