extends Node2D

const Playfab = preload("res://addons/godot-playfab/PlayFab.gd")
const LEADERBOARD_NAME = "TestRanking"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureRect/TimeLabel.text = str(GameManager.stage_time)
	$TextureRect/ScoreLabel.text = str(GameManager.stage_score)
	
	#print("Playfabテスト")
	PlayFabManager.client.connect("logged_in", Callable(self, "_on_login_success"))
	PlayFabManager.client.connect("api_error", Callable(self, "_on_login_error"))
	PlayFabManager.client.connect("server_error", Callable(self, "_on_server_error"))
	#PlayFabManager.client.login_anonymous()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

const AddValue_SCENE = preload("res://ui/AddValueUI.tscn")
func _on_title_button_pressed() -> void:
	#GameManager.load_title_scene()
	get_tree().change_scene_to_packed(AddValue_SCENE)



func _on_login_success(result: LoginResult):
	print("Login")
	print(result)
	
	await change_name("test01")
	await submit_score(GameManager.stage_score, result.SessionTicket)

func change_name(name):
	var body = {
		"DisplayName": name
	}
	PlayFabManager.client.post_dict_auth(body,"/Client/UpdateUserTitleDisplayName",Playfab.AUTH_TYPE.SESSION_TICKET)
	

func submit_score(new_score: int, session_ticket: String):
	var body = {
		 "Statistics": [
			{"StatisticName": LEADERBOARD_NAME, "Value": new_score}
		]
	}
	
	PlayFabManager.client.post_dict_auth(body,"/Client/UpdatePlayerStatistics",Playfab.AUTH_TYPE.SESSION_TICKET, Callable(self, "input_score"))


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
	print(error.error)

func _on_server_error(error):
	print("サーバーエラー")
