extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var hp = 3

func _ready() -> void:
	var signal_manager = get_node("/root/SignalManager")
	
	signal_manager.connect("player_miss", self._on_player_miss)

func _on_player_miss():
	print("Play miss")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		# プレイヤーの向きを決める
		$AnimatedSprite2D.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func damage(amount):
	hp -= amount
	print("Current HP: ", hp)
	if hp <= 0:
		SignalManager.player_miss.emit()
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Hit")
	if body.name == "Enemy1":
		damage(1)
	pass # Replace with function body.
