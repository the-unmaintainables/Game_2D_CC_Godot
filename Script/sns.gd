extends Node2D

const LEADERBOARD_NAME = "TestRanking"
const Playfab = preload("res://addons/godot-playfab/PlayFab.gd")

func _ready() -> void:
	# スコアが記録されるまでは画面をポーズ
	get_tree().paused = true
	submit_score(GameManager.stage_score)
	pass


# Titleボタンが押されたらランキングへ
func _on_title_button_pressed() -> void:
	GameManager.load_ranking_scene()

# 共有用の文字列を返す
func share_words():
	return "ハイスコア: %d点！ #MyGame" % GameManager.stage_score

func _on_twitter_button_pressed() -> void:
	var text = share_words()
	var url = "https://twitter.com/intent/tweet?text=" + text.uri_encode()
	JavaScriptBridge.eval("window.open('%s','_blank')" % url)
	pass # Replace with function body.


func _on_line_button_pressed() -> void:
	var text = share_words()
	var url = "https://line.me/R/msg/text/?" + text.uri_encode()
	JavaScriptBridge.eval("window.open('%s','_blank')" % url)
	pass # Replace with function body.


# スコアをリーダーボードに登録する
func submit_score(new_score: int):
	var body = {
		 "Statistics": [
			{"StatisticName": LEADERBOARD_NAME, "Value": new_score}
		]
	}
	if !PlayFabManager.client.is_connected("api_error", Callable(self, "_on_error")):
		PlayFabManager.client.connect("api_error", Callable(self, "_on_error"), CONNECT_ONE_SHOT)
	if !PlayFabManager.client.is_connected("server_error", Callable(self, "_on_error")):
		PlayFabManager.client.connect("server_error", Callable(self, "_on_error"), CONNECT_ONE_SHOT)
	
	PlayFabManager.client.post_dict_auth(body,"/Client/UpdatePlayerStatistics",Playfab.AUTH_TYPE.SESSION_TICKET,self.sucess_submit_socre)

# PlayFabにスコアを登録できたら呼び出される
func sucess_submit_socre(result):
	print("スコアを記録できました")
	# 画面ポーズの解除
	get_tree().paused = false


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
