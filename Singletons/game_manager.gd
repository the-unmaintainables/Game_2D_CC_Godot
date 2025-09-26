extends Node

const TITLE_SCENE = preload("res://ui/title.tscn")
const STAGE1_SCENE = preload("res://Scene/stage_0.tscn")
const GAMEOVER_SCENE = preload("res://ui/game_over.tscn")
const MAX_CHAGE = 5

var stage_score : int
var stage_time : int

# スマホなのかパソコンなのか
var touch_ui:bool
var mouse_ui:bool

func _ready() -> void:
	var signal_manager = get_node("/root/SignalManager")
	
	signal_manager.connect("stage_start", self.variable_init)
	signal_manager.connect("player_timeout", self.timeout)
	
	var userAgent = str(JavaScriptBridge.get_interface("userAgent"))
	print(userAgent)
	# タッチするデバイスがあるかどうかでスマホかどうかを判定する
	if OS.get_name() == "Android" || OS.get_name() == "iOS":
		print("タッチデバイス → タッチ操作を有効化、マウス操作を無効化")
		enable_touch_ui()
		disable_mouse_ui()
	else:
		print("PC → マウス操作を有効化、タッチ操作を無効化")
		enable_mouse_ui()
		disable_touch_ui()

func enable_touch_ui():
	touch_ui = true
func disable_touch_ui():
	touch_ui = false

func enable_mouse_ui():
	mouse_ui = true
func disable_mouse_ui():
	mouse_ui = false

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
