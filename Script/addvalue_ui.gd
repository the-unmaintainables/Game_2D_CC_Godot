extends Node2D

var error = false
var was_login = false
var button_pressed = false
const LEADERBOARD_NAME = "TestRanking"
const Playfab = preload("res://addons/godot-playfab/PlayFab.gd")

@onready var line_edit_name: LineEdit = $PauseOverlay/PlayerName

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# ポップアップを消す
	$PauseOverlay/PopUp_UI.visible = false
	pass

# Titleボタンが押されたらタイトルへ
func _on_exit_button_pressed() -> void:
	GameManager.load_title_scene()

# 記録を登録するボタンが押されたら
func _on_submit_button_pressed() -> void:
	# スコアが記録されるまでは画面をポーズ
	get_tree().paused = true
	# ボタンもポーズしてるから複数回押されない
	# ログインし終わるまで待機
	if GameManager.was_login:
		# ログインでエラーでなければ実行
		if !error:
			print($PauseOverlay/PlayerName.text)
			# 匿名ログインの名前を入力した名前に変える
			change_name($PauseOverlay/PlayerName.text)
			# スコアをリーダーボードに登録する
			submit_score(GameManager.stage_score)
	else:
		## ログインできていないならボタンを押したことを記録する
		#button_pressed = true
		# 始めにログインすることにしたのでログインできていないなら登録できない
		# 登録できませんみたいなポップアップを出す
		pass
	
	print("ボタン処理の終了")
	
# 匿名ログインの名前を入力した名前に変える
func change_name(name):
	# 名無しなら仮の名前にする
	if name == "":
		name = "gonbei"
	var body = {
		"DisplayName": name
	}
	PlayFabManager.client.post_dict_auth(body,"/Client/UpdateUserTitleDisplayName",Playfab.AUTH_TYPE.SESSION_TICKET)

# スコアをリーダーボードに登録する
func submit_score(new_score: int):
	var body = {
		 "Statistics": [
			{"StatisticName": LEADERBOARD_NAME, "Value": new_score}
		]
	}
	PlayFabManager.client.post_dict_auth(body,"/Client/UpdatePlayerStatistics",Playfab.AUTH_TYPE.SESSION_TICKET,self.sucess_submit_socre)

# PlayFabにスコアを登録できたら呼び出される
func sucess_submit_socre(result):
	print("スコアを記録できました")
	# 画面ポーズの解除
	get_tree().paused = false
	
	# ポップアップをだす。2秒待ってタイトルへ戻る
	$PauseOverlay/PopUp_UI.visible = true
	#await get_tree().create_timer(2.0).timeout
	#GameManager.load_title_scene()

# Titleボタンが押されたらタイトルへ
func _on_title_button_pressed() -> void:
	GameManager.load_title_scene()

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
