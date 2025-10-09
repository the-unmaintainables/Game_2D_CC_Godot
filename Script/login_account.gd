extends Control

@onready var email_input: LineEdit = $EmailInput
@onready var password_input: LineEdit = $PasswordInput

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func login_email():
	var email = email_input.text
	var password = password_input.text
	
	print(email)
	print(password)

	# 必須入力チェック
	if email.is_empty() or password.is_empty():
		print("エラー: メールアドレス、パスワードをすべて入力してください。")
		return

	if password.length() < 6:
		print("エラー: パスワードは6文字以上である必要があります。")
		return
	
	if !PlayFabManager.client.is_connected("logged_in", Callable(self, "_on_logged_in")):
		PlayFabManager.client.connect("logged_in", Callable(self, "_on_logged_in"), CONNECT_ONE_SHOT)
	if !PlayFabManager.client.is_connected("api_error", Callable(self, "_on_login_error")):
		PlayFabManager.client.connect("api_error", Callable(self, "_on_login_error"), CONNECT_ONE_SHOT)
	if !PlayFabManager.client.is_connected("server_error", Callable(self, "_on_server_error")):
		PlayFabManager.client.connect("server_error", Callable(self, "_on_server_error"), CONNECT_ONE_SHOT)
	
	PlayFabManager.client.login_with_email(email, password)
	
# すでにあるアカウントにログインできた
func _on_logged_in(result):
	print("ログイン成功")
	# 画面遷移する
	GameManager.load_title_scene()

# アカウントにログインできない場合
func _on_login_error(error):
	print("ログインエラー")
	print(error.errorCode)
	match error.errorCode:
		1001:
			# 存在しないアカウント
			$LoginMessage.text = "ユーザーが見つかりません。"
			print("Noユーザー")
		1142:
			# パスワードが間違っている
			$LoginMessage.text = "パスワードが間違っています。"
			print("Noパスワード")
		1030:
			# アカウントが停止されている
			$LoginMessage.text = "あなたのアカウントは利用停止されています。"
			print("Noアカウント")
		_:
			# その他の一般的なエラー
			print("その他のエラー:" + str(error.errorMessage))
			$LoginMessage.text = "ログインにシッパイしました"
	$LoginMessage.visible = true
	$LoginMessage.text =  str(error.errorMessage)

# 匿名ログインを行う
func login_anony():
	if !PlayFabManager.client.is_connected("logged_in", Callable(self, "_on_logged_in")):
		PlayFabManager.client.connect("logged_in", Callable(self, "_on_logged_in"), CONNECT_ONE_SHOT)
	if !PlayFabManager.client.is_connected("api_error", Callable(self, "_on_server_error")):
		PlayFabManager.client.connect("api_error", Callable(self, "_on_server_error"), CONNECT_ONE_SHOT)
	if !PlayFabManager.client.is_connected("server_error", Callable(self, "_on_server_error")):
		PlayFabManager.client.connect("server_error", Callable(self, "_on_server_error"), CONNECT_ONE_SHOT)
	# 匿名ログインする
	PlayFabManager.client.login_anonymous()

func _on_server_error(error):
	print(error["ErrorMessage"])
	$LoginMessage.text = "もう一度お試しください"

func _on_new_account_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/CreateAccount.tscn")


func _on_login_button_pressed() -> void:
	login_email()


func _on_anonymous_login_button_pressed() -> void:
	login_anony()


# ノードがシーンツリーから削除されるときに解除するのが一般的です
func _exit_tree():
	disconnect_playfab_signals()
	
func disconnect_playfab_signals():
	if PlayFabManager.client.is_connected("registered", Callable(self, "_on_logged_in")):
		PlayFabManager.client.disconnect("registered", Callable(self, "_on_logged_in"))
	if PlayFabManager.client.is_connected("api_error", Callable(self, "_on_server_error")):
		PlayFabManager.client.disconnect("api_error", Callable(self, "_on_server_error"))
	if PlayFabManager.client.is_connected("server_error", Callable(self, "_on_server_error")):
		PlayFabManager.client.disconnect("server_error", Callable(self, "_on_server_error"))
