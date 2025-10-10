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
	if !PlayFabManager.client.is_connected("api_error", Callable(self, "_on_error")):
		PlayFabManager.client.connect("api_error", Callable(self, "_on_error"), CONNECT_ONE_SHOT)
	if !PlayFabManager.client.is_connected("server_error", Callable(self, "_on_error")):
		PlayFabManager.client.connect("server_error", Callable(self, "_on_error"), CONNECT_ONE_SHOT)
	PlayFabManager.client.post_dict_auth(body,"/Client/UpdateUserTitleDisplayName",PlayFabManager.client.AUTH_TYPE.SESSION_TICKET, Callable(self, "_on_change_name"))


func _on_change_name(result):
	print("名前を変更しました")
	# ポップアップを出すか画面遷移
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
