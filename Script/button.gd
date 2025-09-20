extends Button

# Buttonノードにアタッチするスクリプト

@onready var label_node = $Label

# 通常時の色とホバー時の色
var normal_color = Color("ffffff")
var hover_color = Color("ffff00")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# シグナルに接続
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	
	# 初期色を設定
	label_node.set("theme_override_colors/font_color", normal_color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# マウスがボタンの家に乗った時に
func _on_mouse_entered():
	# テキストの色を変更
	label_node.set("theme_override_colors/font_color", hover_color)

# マウスがボタンから外れた時
func _on_mouse_exited():
	# テキストの色を変更
	label_node.set("theme_override_colors/font_color", normal_color)
