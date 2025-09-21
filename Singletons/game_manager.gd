extends Node

const TITLE_SCENE = preload("res://ui/title.tscn")
const STAGE1_SCENE = preload("res://Scene/Main.tscn")
const MAX_CHAGE = 5

var stage_score : int
var stage_time : int

func _ready() -> void:
	var signal_manager = get_node("/root/SignalManager")
	
	signal_manager.connect("stage_start", self.variable_init)

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
