extends Control

@onready var nameinput = $NameInput

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# ボタンが押されたら名前を変更
func _on_button_pressed() -> void:
	change_name()

# ログインしているPlayFabのアカウントの表示名を変更する
func change_name():
	var name = nameinput.text
	var body = {
		"DisplayName": name
	}
	PlayFabManager.client.post_dict_auth(body,"/Client/UpdateUserTitleDisplayName",PlayFabManager.client.AUTH_TYPE.SESSION_TICKET, Callable(self, "_on_change_name"))


func _on_change_name(result):
	print("名前を変更しました")
	# ポップアップを出すか画面遷移
	GameManager.load_title_scene()
