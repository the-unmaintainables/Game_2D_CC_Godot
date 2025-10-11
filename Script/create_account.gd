extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 例: 英数字のみ許可
	$IDInput.regex = "^[A-Za-z0-9]*$"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	register_new_user()


@onready var id_input: LineEdit = $IDInput
@onready var password_input: LineEdit = $PasswordInput

# ----------------------------------------------------
# ユーザー登録処理を開始する関数
# ----------------------------------------------------
func register_new_user():
	var id = id_input.text
	var password = password_input.text
	
	print(id)
	print(password)

	# 必須入力チェック
	if id.is_empty() or password.is_empty():
		print("エラー: メールアドレス、パスワードをすべて入力してください。")
		return

	if password.length() < 6:
		print("エラー: パスワードは6文字以上である必要があります。")
		return

	# シグナル接続 (PlayFabManagerを使用している場合はそのシグナルに接続)
	if !PlayFabManager.client.is_connected("registered", Callable(self, "_on_registration_success")):
		PlayFabManager.client.connect("registered", Callable(self, "_on_registration_success"), CONNECT_ONE_SHOT)
	if !PlayFabManager.client.is_connected("api_error", Callable(self, "_on_api_call_failed")):
		PlayFabManager.client.connect("api_error", Callable(self, "_on_api_call_failed"), CONNECT_ONE_SHOT)
	if !PlayFabManager.client.is_connected("server_error", Callable(self, "_on_server_error")):
		PlayFabManager.client.connect("server_error", Callable(self, "_on_server_error"), CONNECT_ONE_SHOT)
		
	# API呼び出し
	# idとパスワードだけでアカウントを作成とログイン
	PlayFabManager.client.register_email_password(id, password)
	
	print("ユーザー登録リクエストを送信しました...")

# ----------------------------------------------------
# 登録成功時の処理
# ----------------------------------------------------
func _on_registration_success(result):
	# 登録が成功すると、自動的にログイン状態になります
	print("✅ 登録成功！プレイヤーID:", result.PlayFabId)
	# 画面遷移やメインメニューへの移動など
	get_tree().change_scene_to_file("res://ui/ChangeName.tscn")

# ----------------------------------------------------
# 失敗時の処理
# ----------------------------------------------------
func _on_api_call_failed(error):
	print("APIエラー")
	print("❌ 登録失敗。エラーメッセージ:")
	print(error)
	var errorMessage = error.errorMessage
	var error_code = error.error_code
	print(error_code)
	print(errorMessage)
	print(error.code)
	# エラーコードに応じてユーザーにメッセージを表示（例: ユーザー名が既に使用されている、パスワードが短すぎるなど）
	match error_code:
		# 1. ユーザー名、メールアドレスの重複エラー
		1007: # UsernameNotAvailable
			$LoginMessage.text = "This ID is already in use."
		1023: # EmailAddressNotAvailable
			$LoginMessage.text = "This email address is already in use."
		# 5. その他のエラー
		_:
			# より詳細なデバッグ情報（開発者向け）
			print("未処理のエラーコード:", error_code, "メッセージ:", errorMessage)
			$LoginMessage.text = "Registration failed."
	$LoginMessage.visible = true

func _on_server_error(error):
	print("serverエラー")
	print(error.errorMessage)
	$LoginMessage.text = "Please try again."

# ノードがシーンツリーから削除されるときに解除するのが一般的です
func _exit_tree():
	disconnect_playfab_signals()
	
func disconnect_playfab_signals():
	if PlayFabManager.client.is_connected("registered", Callable(self, "_on_registration_success")):
		PlayFabManager.client.disconnect("registered", Callable(self, "_on_registration_success"))
	if PlayFabManager.client.is_connected("api_error", Callable(self, "_on_api_call_failed")):
		PlayFabManager.client.disconnect("api_error", Callable(self, "_on_api_call_failed"))
	if PlayFabManager.client.is_connected("server_error", Callable(self, "_on_server_error")):
		PlayFabManager.client.disconnect("server_error", Callable(self, "_on_server_error"))
