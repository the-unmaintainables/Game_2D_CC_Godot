extends Node2D

const Playfab = preload("res://addons/godot-playfab/PlayFab.gd")
const LEADERBOARD_NAME = "TestRanking"

# ランキング項目シーン
const RANK_ENTRY_SCENE = preload("res://ui/rank_entry.tscn")
# ランキング項目を格納する
@onready var rank_list_container: VBoxContainer = $CanvasLayer/ScrollContainer/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#PlayFabManager.client.connect("logged_in", Callable(self, "_on_login_success"))
	#PlayFabManager.client.connect("api_error", Callable(self, "_on_login_error"))
	#PlayFabManager.client.connect("server_error", Callable(self, "_on_server_error"))
	#PlayFabManager.client.login_anonymous()
	
	fetch_leaderboard()
	pass
	
func _on_login_success(result: LoginResult):
	print("Login")
	

func fetch_leaderboard():
	var statistic_name = LEADERBOARD_NAME  # PlayFab側で設定した統計名
	var max_results = 100
	var body = {
		"StatisticName": statistic_name, "StartPosition": 0, "MaxResultsCount": max_results
	}
	if !PlayFabManager.client.is_connected("api_error", Callable(self, "_on_error")):
		PlayFabManager.client.connect("api_error", Callable(self, "_on_error"), CONNECT_ONE_SHOT)
	if !PlayFabManager.client.is_connected("server_error", Callable(self, "_on_error")):
		PlayFabManager.client.connect("server_error", Callable(self, "_on_error"), CONNECT_ONE_SHOT)
	
	PlayFabManager.client.post_dict_auth(body,"/Client/GetLeaderboard", Playfab.AUTH_TYPE.SESSION_TICKET, Callable(self, "_on_PlayFab_leaderboard_success"))
	

func _on_PlayFab_leaderboard_success(result):
	#print("ランキング")
	#print(result)
	var entries = result["data"]["Leaderboard"]
	for entry in entries:
		var name = entry["DisplayName"]
		var score = entry["StatValue"]
		var rank = entry["Position"] + 1
		#print("%d位: %s - %d点" % [rank, name, score])
		rank = "%3d" % rank
		score = "%d" % score
		# カスタムシーンを作成
		var rank_entry_ui = RANK_ENTRY_SCENE.instantiate()
		# カスタムシーンのLabelに値を設定
		rank_entry_ui.get_node("RankLabel").text = str(rank)
		rank_entry_ui.get_node("NameLabel").text = name
		rank_entry_ui.get_node("ScoreLabel").text = str(score)
		# コンテナに追加
		rank_list_container.add_child(rank_entry_ui)
	
	# 下までスクロールしきらないので空の要素を追加
	# カスタムシーンを作成
	var rank_entry_ui = RANK_ENTRY_SCENE.instantiate()
	# カスタムシーンのLabelに値を設定
	rank_entry_ui.get_node("RankLabel").text = ""
	rank_entry_ui.get_node("NameLabel").text = ""
	rank_entry_ui.get_node("ScoreLabel").text = ""
	# コンテナに追加
	rank_list_container.add_child(rank_entry_ui)

# 押したらタイトルへ戻る
func _on_button_pressed() -> void:
	GameManager.load_title_scene()

# PlayFabのエラー
func _on_error(error):
	print("スコアの登録エラー")
	print(error.errorMessage)

# ノードがシーンツリーから削除されるときに解除するのが一般的です
func _exit_tree():
	disconnect_playfab_signals()
	
func disconnect_playfab_signals():
	if PlayFabManager.client.is_connected("api_error", Callable(self, "_on_error")):
		PlayFabManager.client.disconnect("api_error", Callable(self, "_on_error"))
	if PlayFabManager.client.is_connected("server_error", Callable(self, "_on_error")):
		PlayFabManager.client.disconnect("server_error", Callable(self, "_on_error"))
