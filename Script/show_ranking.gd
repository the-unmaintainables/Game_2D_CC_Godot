extends Node2D

const Playfab = preload("res://addons/godot-playfab/PlayFab.gd")
const LEADERBOARD_NAME = "TestRanking"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayFabManager.client.connect("logged_in", Callable(self, "_on_login_success"))
	PlayFabManager.client.connect("api_error", Callable(self, "_on_login_error"))
	PlayFabManager.client.connect("server_error", Callable(self, "_on_server_error"))
	PlayFabManager.client.login_anonymous()
	
func _on_login_success(result: LoginResult):
	print("Login")
	fetch_leaderboard()

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
		var name = entry["DisplayName"]
		var score = entry["StatValue"]
		var rank = entry["Position"]
		print("%d位: %s - %d点" % [rank + 1, name, score])
		$CanvasLayer/RankingLabel.text += "%d位: %s - %d点\n" % [rank + 1, name, score]
