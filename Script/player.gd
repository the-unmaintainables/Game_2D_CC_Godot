extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -700.0
# 基準となる画面サイズ（デザイン時の解像度）
const BASE_WIDTH = 1920
const BASE_HEIGHT = 1080

@export var hp = 1
@export var bullet_scene: PackedScene
var current_chage
var max_chage = GameManager.MAX_CHAGE

@onready var chage_timer = $ChageTimer
@onready var default_position = position

func _ready() -> void:
	# アニメーションはPlay処理をしないと始めのアニメーションすら動かない
	$kirakira1.play("default")
	$kirakira2.play("default")
	
	var signal_manager = get_node("/root/SignalManager")
	
	signal_manager.connect("player_miss", self._on_player_miss)
	signal_manager.connect("player_timeout", self._on_player_timeout)
	
	# チャージ数の初期化
	current_chage = 0
	SignalManager.update_chage.emit(current_chage)
	
	
# プレイヤーがミスした時
func _on_player_miss():
	print("Play miss")
	position = default_position
	hp = 1

# 時間切れ
func _on_player_timeout():
	print("Player timeout")
	SignalManager.player_miss.emit()

func _physics_process(delta: float) -> void:
	# 現在のビューポートのサイズを取得
	var current_size = get_viewport().size
	
	# 幅と高さの比率を計算
	var scale_x = current_size.x / float(BASE_WIDTH)
	var scale_y = current_size.y / float(BASE_HEIGHT)
	
	# どちらか小さい方の比率をUI全体のスケールとして使用
	var scale_factor = min(scale_x, scale_y)
	scale_factor = 1
	
	# 重力
	if not is_on_floor():
		velocity += get_gravity() * delta * scale_factor * 1.5
		$AnimatedSprite2D.play("jump")

	# ジャンプ処理
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * scale_factor

	# 左右移動の処理
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		# アニメーションの変更
		if is_on_floor():
			if $AnimatedSprite2D.animation != "walk":
				$AnimatedSprite2D.animation = "walk"
		velocity.x = direction * SPEED * scale_factor
		# プレイヤーの向きを決める
		$AnimatedSprite2D.flip_h = direction < 0
		if direction < 0:
			# キラキラも反転
			$kirakira1.position.x = min($kirakira1.position.x,-$kirakira1.position.x)
			$kirakira2.position.x = max($kirakira2.position.x,-$kirakira2.position.x)
		else:
			# キラキラも反転
			$kirakira1.position.x = max($kirakira1.position.x,-$kirakira1.position.x)
			$kirakira2.position.x = min($kirakira2.position.x,-$kirakira2.position.x)
	else:
		if is_on_floor():
			$AnimatedSprite2D.animation = "idle"
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# 発射ボタンが押されたら弾を発射する
	if Input.is_action_just_pressed("attack"):
		fire_bullet()
	
	# チャージボタンが押されたら
	if Input.is_action_pressed("chage"):
		# タイマーがまだ動いていないなら開始
		if chage_timer.is_stopped():
			chage_timer.start()
			$kirakira1.hide()
			$kirakira2.hide()
	else:
		# ボタンが話されたらタイマーを停止
		chage_timer.stop()
		$kirakira1.show()
		$kirakira2.show()

# 弾を打つ処理
func fire_bullet():
	if bullet_scene == null:
		print("エラー: 弾のシーン")
		return
	# チャージがなかったら打たない
	if current_chage <= 0:
		return
	
	# チャージ数の変更
	current_chage -= 1
	SignalManager.update_chage.emit(current_chage)
	
	# 弾のインスタンスを作成
	var bullet_instance = bullet_scene.instantiate()
	# 弾の位置を設定
	bullet_instance.global_position = position
	# 弾の向きを設定
	if $AnimatedSprite2D.flip_h:
		bullet_instance.rotation = deg_to_rad(180)
	
	# 現在のシーンに弾を追加
	self.get_parent().add_child(bullet_instance)
	
# ダメージを受ける。死亡処理も記述
func damage(amount, penetration=false):
	# チャージしていないときは無敵
	if not penetration and chage_timer.is_stopped():
		return
	hp -= amount
	print("Current HP: ", hp)
	if hp <= 0:
		SignalManager.player_miss.emit()

# プレイヤーの当たり判定に当たる
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Enemy1":
		damage(1)

# チャージタイマーの時間が来た時の処理 1秒に一回
func _on_chage_timer_timeout() -> void:
	current_chage = min(current_chage+1, max_chage)
	SignalManager.update_chage.emit(current_chage)
	print("現在のチャージ数： " + str(current_chage))
