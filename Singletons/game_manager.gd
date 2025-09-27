extends Node

const TITLE_SCENE = preload("res://ui/title.tscn")
const STAGE1_SCENE = preload("res://Scene/stage_0.tscn")
const GAMEOVER_SCENE = preload("res://ui/game_over.tscn")
const MAX_CHAGE = 5

var stage_score : int
var stage_time : int

# スマホなのかパソコンなのか
var touch_ui : bool
var mouse_ui : bool

func _ready() -> void:
	var signal_manager = get_node("/root/SignalManager")
	
	signal_manager.connect("stage_start", self.variable_init)
	signal_manager.connect("player_timeout", self.timeout)
	signal_manager.connect("stage_clear", self.input_init)
	
	
	var navigator = JavaScriptBridge.get_interface("navigator")
	var userAgent = str(navigator.userAgent).to_lower()
	print(userAgent)
	var is_pc = true
	if userAgent.find("windows nt") != -1:
		print("「Microsoft Windows」をお使いですね!")
		is_pc = true
	elif userAgent.find("android") != -1:
		print("「Android」をお使いですね!");
		is_pc = false
	elif userAgent.find("iphone") != -1 || userAgent.find("ipad") != -1:
		print("「iOS」をお使いですね!");
		is_pc = false
	elif userAgent.find("mac os x") != -1:
		print("「macOS」をお使いですね!");
		is_pc = true
	else:
		is_pc = true
	
	#is_pc = false
	# スマホなら
	if not is_pc:
		print("タッチデバイス → タッチ操作を有効化、マウス操作を無効化")
		enable_touch_ui()
		disable_mouse_ui()
	else:
		print("PC → マウス操作を有効化、タッチ操作を無効化")
		enable_mouse_ui()
		disable_touch_ui()
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

# stage1に移動
func load_stage1_scene():
	get_tree().change_scene_to_packed(STAGE1_SCENE)

# ゲームオーバーへ移動
func load_gameover_scene():
	get_tree().change_scene_to_packed(GAMEOVER_SCENE)
