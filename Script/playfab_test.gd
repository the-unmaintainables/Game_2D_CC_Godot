extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Playfabテスト")
	PlayFabManager.client.connect("logged_in", Callable(self, "_on_login_success"))
	PlayFabManager.client.connect("api_error", Callable(self, "_on_login_error"))
	PlayFabManager.client.connect("server_error", Callable(self, "_on_login_error"))
	
	PlayFabManager.client.login_anonymous()
	#add_child(playfab)
	#playfab.login_anonymous()
	pass # Replace with function body.

func _on_login_success(result: LoginResult):
	print("Login")
	print(result)

func _on_login_error(error):
	print("ログイン失敗")
	print(error)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
