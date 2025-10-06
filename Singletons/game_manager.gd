extends Node

var was_login = false # PlayFabのログインしているか

const TITLE_SCENE = preload("res://ui/title.tscn")
const STAGE1_SCENE = preload("res://Scene/stage_0.tscn")
const GAMEOVER_SCENE = preload("res://ui/game_over.tscn")
const RANKING_SCENE = preload("res://ui/show_ranking.tscn")
const CLEAR_SCENE = preload("res://ui/clear.tscn")

const MAX_CHAGE = 5 # プレイヤーの弾の最大値

var stage_score : int = 0 # ゲームのスコア
var stage_time : int = 0 # クリアした時に残っている時間

# スマホなのかパソコンなのか
var touch_ui : bool
var mouse_ui : bool

func _ready() -> void:
	var signal_manager = get_node("/root/SignalManager")
	
	signal_manager.connect("stage_start", self.variable_init)
	signal_manager.connect("player_timeout", self.timeout)
	signal_manager.connect("stage_start", self.input_init)
	
	# ゲームが始まったらPlayFabに匿名ログインして準備しておく
	PlayFabManager.client.connect("logged_in", Callable(self, "_on_login_success"))
	PlayFabManager.client.connect("api_error", Callable(self, "_on_api_error"))
	PlayFabManager.client.connect("server_error", Callable(self, "_on_server_error"))
	# 匿名ログインする
	PlayFabManager.client.login_anonymous()
	
	# タッチデバイスがあるかでスマホを判定する
	var is_pc = true
	var has_touch_end = false
	if OS.get_name() == "Web":
		has_touch_end = _check_javascript_property_existence("document.ontouchend")
	
	if has_touch_end:
		is_pc = false
		print("JavaScriptのdocumentオブジェクトは 'ontouchend' イベントをサポートしています。")
	else:
		is_pc = true
		print("JavaScriptのdocumentオブジェクトは 'ontouchend' イベントをサポートしていません。")
	
	# スマホなら
	if not is_pc:
		print("タッチデバイス → タッチ操作を有効化、マウス操作を無効化")
		enable_touch_ui()
		disable_mouse_ui()
	else:
		print("PC → マウス操作を有効化、タッチ操作を無効化")
		enable_mouse_ui()
		disable_touch_ui()
		# パソコン操作ならクリックを攻撃に割り当て
		var ev_click = InputEventMouseButton.new()
		ev_click.button_index = MOUSE_BUTTON_LEFT
		InputMap.action_add_event("attack", ev_click)

func enable_touch_ui():
	touch_ui = true
func disable_touch_ui():
	touch_ui = false

func enable_mouse_ui():
	mouse_ui = true
func disable_mouse_ui():
	mouse_ui = false

# ログイン成功時の関数
func _on_login_success(result):
	print("ログイン成功")
	was_login = true
	# ログインを通知するシグナル
	SignalManager.playfab_login.emit()
# PlayFabのリクエストがAPIエラーの場合
func _on_api_error(result):
	print("api_error")
# PlayFabのリクエストがサーバーエラーの場合
func _on_server_error(result):
	print("server_error")
	PlayFabManager.client.login_anonymous()


# JavaScriptのオブジェクト/プロパティの存在をチェックする関数
func _check_javascript_property_existence(property_path: String) -> bool:
	# JavaScriptコードを文字列として定義
	# '!!' (二重否定) は、値が null, undefined, 0, false, '' などである場合に false を返し、
	# それ以外の場合（存在する場合）に true を返すために使用される [1]
	var js_code = "(!!(typeof document.documentElement.ontouchend!== 'undefined'))"
	JavaScriptBridge.eval("console.log(" + js_code + ");")
	# JavaScriptBridge.eval() を使用してコードを実行
	var result = JavaScriptBridge.eval(js_code, true)
	
	return result

# javascriptで音楽が再生できるようにする
func _resume_web_audio():
	# Godot 4.3以降、Webでのオーディオ再生はWeb Audio APIに依存している [1]
	# そのため、ユーザー操作があった際にオーディオコンテキストをresume()する必要がある [2]
	var js_code = """
		// Godotが公開しているEngineオブジェクトにアクセスし、オーディオコンテキストを取得
		if (typeof Engine!== 'undefined' && Engine.get_audio_context) {
			var audio_context = Engine.get_audio_context();
			// 状態が'suspended'（停止中）であれば再開を試みる
			if (audio_context && audio_context.state === 'suspended') {
				audio_context.resume().then(function() {
					console.log('Web AudioContext resumed by user gesture.');
				}).catch(function(error) {
					console.error('Failed to resume AudioContext:', error);
				});
			}
		}
	"""
	# JavaScriptBridgeを使用してJavaScriptコードを実行
	JavaScriptBridge.eval(js_code)

# ステージをクリアしたら入力を初期化する
func input_init():
	print("input_init")
	Input.action_release("move_right")
	Input.action_release("move_left")
	Input.action_release("jump")
	Input.action_release("attack")
	Input.action_release("chage")
	Input.action_release("pause")

# 時間切れになったらゲームオーバー画面へ飛ぶ
func timeout():
	load_gameover_scene()

# スコアとタイムの初期化
func variable_init():
	print("変数の初期化")
	stage_score = 0
	stage_time = 0

# タイトルへ移動
func load_title_scene():
	get_tree().change_scene_to_packed(TITLE_SCENE)

# stage1へ移動
func load_stage1_scene():
	get_tree().change_scene_to_packed(STAGE1_SCENE)

# ゲームオーバーへ移動
func load_gameover_scene():
	get_tree().change_scene_to_packed(GAMEOVER_SCENE)

# ランキングへ移動
func load_ranking_scene():
	get_tree().change_scene_to_packed(RANKING_SCENE)

# クリア画面へ移動
func load_clear_scene():
	get_tree().change_scene_to_packed(CLEAR_SCENE)
