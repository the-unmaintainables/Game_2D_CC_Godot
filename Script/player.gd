extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -700.0

@export var hp = 1
@export var bullet_scene: PackedScene
@export var bullet_cooldown = 0.5 # 弾のクールタイム
var can_fire = true # 弾が打てる状態か
var is_star = true # 無敵かどうか
var current_chage # 現在のチャージ数
var max_chage = GameManager.MAX_CHAGE # プレイヤーの最大チャージ数

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
	# チャージ数の初期化
	current_chage = 0
	SignalManager.update_chage.emit(current_chage)

# 時間切れ
func _on_player_timeout():
	print("Player timeout")
	SignalManager.player_miss.emit()

func _physics_process(delta: float) -> void:
	
	# 重力
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.5
		$AnimatedSprite2D.play("jump")

	# ジャンプ処理
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 左右移動の処理
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		# アニメーションの変更
		if is_on_floor():
			if $AnimatedSprite2D.animation != "walk":
				$AnimatedSprite2D.animation = "walk"
		velocity.x = direction * SPEED
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
	if Input.is_action_just_pressed("chage"):
		chage_bullet()

# 弾を打つ処理
func fire_bullet():
	if bullet_scene == null:
		print("エラー: 弾のシーン")
		return
	# チャージがなかったら打たない
	if current_chage <= 0:
		return
	# クールダウン中なら打てない
	if !can_fire:
		return
	
	# 弾のクールダウンの処理
	can_fire = false
	# can_fireをクールダウンが終わったらtrueに戻す,無敵も戻す
	get_tree().create_timer(bullet_cooldown).timeout.connect(func():
		can_fire = true;is_star = true;$kirakira1.show();$kirakira2.show())
	# 弾のクールダウン中はチャージをできないようにする
	chage_bullet()
	
	# 無敵の解除
	is_star = false
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
		bullet_instance.global_position.x -= 50
	else:
		bullet_instance.global_position.x += 50
	
	# 現在のシーンに弾を追加
	self.get_parent().add_child(bullet_instance)
	
	# 弾が出たら音も出す
	$ShotSound.play()

# チャージボタンを押した処理
func chage_bullet():
	# 弾のクールタイム中ならチャージできない
	if !can_fire:
		# チャージをやめて、キラキラも消す
		chage_timer.stop()
		$kirakira1.hide()
		$kirakira2.hide()
		is_star = false
	# タイマーがまだ動いていないならチャージを開始
	elif chage_timer.is_stopped():
		chage_timer.start()
		$kirakira1.hide()
		$kirakira2.hide()
		# 無敵の解除
		is_star = false
	else: # タイマーが動いているならチャージをやめる
		chage_timer.stop()
		$kirakira1.show()
		$kirakira2.show()
		# 無敵にする
		is_star = true


# ダメージを受ける。死亡処理も記述(penetrationはtureなら奈落)
func damage(amount, penetration=false):
	# チャージしていないときは無敵, 
	if not penetration and is_star:
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
