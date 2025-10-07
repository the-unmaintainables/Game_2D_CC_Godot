extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	register_new_user()


@onready var email_input: LineEdit = $EmailInput
@onready var password_input: LineEdit = $PasswordInput

# ----------------------------------------------------
# ユーザー登録処理を開始する関数
# ----------------------------------------------------
func register_new_user():
	var email = email_input.text
	var password = password_input.text
	
	print(email)
	print(password)

	# 必須入力チェック
	if email.is_empty() or password.is_empty():
		print("エラー: ユーザー名、メールアドレス、パスワードをすべて入力してください。")
		return

	if password.length() < 6:
		print("エラー: パスワードは6文字以上である必要があります。")
		return

	var request = {
		"TitleId": PlayFabManager.client._title_id,
		"Username": email,
		"Email": email,
		"Password": password,
		# DisplayNameはオプション。ユーザー名と同じにする場合など
		#"DisplayName": user_name
		# "RequireBothUsernameAndEmail": false # デフォルト設定でOK
	}

	# シグナル接続 (PlayFabManagerを使用している場合はそのシグナルに接続)
	PlayFabManager.client.connect("registered", Callable(self, "_on_registration_success"))
	PlayFabManager.client.connect("api_error", Callable(self, "_on_api_call_failed"))
	
	# API呼び出し
	# メールアドレスとパスワードだけでアカウントを作成とログイン
	PlayFabManager.client.register_email_password(email, password)
	
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
	print(error["errorMessage"])
	# エラーコードに応じてユーザーにメッセージを表示（例: ユーザー名が既に使用されている、パスワードが短すぎるなど）
